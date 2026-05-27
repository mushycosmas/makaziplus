import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository repository;

  CategoryProvider({required this.repository});

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  /// GETTERS
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// FETCH CATEGORIES
  Future<void> fetchCategories() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final result = await repository.getCategories();

      if (result.isEmpty) {
        _errorMessage = "No categories found";
      }

      _categories = result;
    } catch (e) {
      _errorMessage = _handleError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// REFRESH
  Future<void> refreshCategories() async {
    await fetchCategories();
  }

  /// CLEAR
  void clear() {
    _categories = [];
    _errorMessage = null;
    notifyListeners();
  }

  /// INTERNAL LOADING HANDLER
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// CLEAN ERROR MESSAGE
  String _handleError(Object e) {
    debugPrint("CategoryProvider Error: $e");

    if (e.toString().contains("SocketException")) {
      return "No internet connection";
    } else if (e.toString().contains("404")) {
      return "Categories endpoint not found";
    } else if (e.toString().contains("500")) {
      return "Server error. Try again later";
    }

    return "Something went wrong";
  }
}