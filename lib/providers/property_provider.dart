import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../repositories/property_repository.dart';

class PropertyProvider extends ChangeNotifier {
  final PropertyRepository repository;

  PropertyProvider({required this.repository});

  List<Property> _properties = [];
  bool _isLoading = false;
  String? _error;

  List<Property> get properties => _properties;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProperties() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _properties = await repository.getProperties();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}