// lib/providers/property_submission_provider.dart

import 'dart:io';
import 'dart:convert'; // ✅ Add this for jsonEncode/jsonDecode if needed
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/property_manage_api.dart' as PropertyApi;

class PropertySubmissionState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final dynamic data;

  const PropertySubmissionState({
    required this.isLoading,
    required this.isSuccess,
    this.error,
    this.data,
  });

  factory PropertySubmissionState.initial() {
    return const PropertySubmissionState(
      isLoading: false,
      isSuccess: false,
      error: null,
      data: null,
    );
  }

  PropertySubmissionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    dynamic data,
    bool clearError = false,
    bool clearData = false,
  }) {
    return PropertySubmissionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : (error ?? this.error),
      data: clearData ? null : (data ?? this.data),
    );
  }
}

class PropertySubmissionNotifier
    extends StateNotifier<PropertySubmissionState> {
  PropertySubmissionNotifier()
      : super(PropertySubmissionState.initial());

  Future<void> submitProperty({
    required Map<String, dynamic> data,
    required List<File> images,
    String? token,
  }) async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      clearError: true,
    );

    try {
      // ✅ Prepare data - ensure Lists are converted to JSON strings if needed
      final preparedData = Map<String, dynamic>.from(data);
      
      // If amenityIds is a List, convert to JSON string
      if (preparedData['amenityIds'] is List) {
        preparedData['amenityIds'] = jsonEncode(preparedData['amenityIds']);
      }

      final response = await PropertyApi.PropertyManageApi.createProperty(
        preparedData,
        images,
        token: token,
      );

      if (response['success'] == true) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          data: response['data'],
          clearError: true,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: response['message'] ?? 'Failed to submit property.',
          clearData: true,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
        clearData: true,
      );
    }
  }

  void reset() {
    state = PropertySubmissionState.initial();
  }
}

final propertySubmissionProvider = StateNotifierProvider<
    PropertySubmissionNotifier,
    PropertySubmissionState>((ref) {
  return PropertySubmissionNotifier();
});