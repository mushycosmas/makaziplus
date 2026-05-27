import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryRepository {
  final CategoryService categoryService;

  CategoryRepository({required this.categoryService});

  /// 🔹 Get all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await categoryService.fetchCategories();
      return response;
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  /// 🔹 Optional: Get single category by ID
  Future<Category?> getCategoryById(int id) async {
    try {
      final categories = await categoryService.fetchCategories();

      return categories.firstWhere(
        (category) => category.id == id,
        orElse: () => throw Exception('Category not found'),
      );
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  /// 🔹 Optional: Refresh categories (useful for pull-to-refresh)
  Future<List<Category>> refreshCategories() async {
    return await categoryService.fetchCategories();
  }
}