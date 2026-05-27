import '../models/property_model.dart';
import '../services/property_service.dart';

class PropertyRepository {
  final PropertyService service;

  PropertyRepository({required this.service});

  // =========================
  // GET ALL PROPERTIES
  // =========================
  Future<List<Property>> getProperties() async {
    try {
      return await service.fetchProperties();
    } catch (e) {
      throw Exception("Failed to load properties: $e");
    }
  }

  // =========================
  // GET SINGLE PROPERTY
  // =========================
  Future<Property> getPropertyById(int id) async {
    try {
      return await service.fetchPropertyById(id);
    } catch (e) {
      throw Exception("Failed to load property: $e");
    }
  }

  // =========================
  // CREATE PROPERTY
  // =========================
  Future<Property> createProperty(Map<String, dynamic> data) async {
    try {
      return await service.createProperty(data);
    } catch (e) {
      throw Exception("Failed to create property: $e");
    }
  }

  // =========================
  // UPDATE PROPERTY
  // =========================
  Future<Property> updateProperty(int id, Map<String, dynamic> data) async {
    try {
      return await service.updateProperty(id, data);
    } catch (e) {
      throw Exception("Failed to update property: $e");
    }
  }

  // =========================
  // DELETE PROPERTY
  // =========================
  Future<void> deleteProperty(int id) async {
    try {
      await service.deleteProperty(id);
    } catch (e) {
      throw Exception("Failed to delete property: $e");
    }
  }
}