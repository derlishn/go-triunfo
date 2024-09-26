import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/category_dto.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Colección de categorías en Firestore
  CollectionReference get _categoriesCollection =>
      _firestore.collection('categories');

  // Obtener todas las categorías con paginación (solo categorías activas)
  Future<QuerySnapshot> fetchCategories({int limit = 6, DocumentSnapshot? startAfter}) async {
    try {
      Query query = _categoriesCollection
          .where('isActive', isEqualTo: true) // Solo obtener categorías activas
          .orderBy('name')
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      return await query.get();
    } catch (e) {
      throw Exception('Error al cargar categorías: $e');
    }
  }

  // Obtener todas las categorías (sin importar el estado)
  Future<List<CategoryDTO>> fetchAllCategoriesIncludingInactive() async {
    try {
      final querySnapshot = await _categoriesCollection.get();
      return querySnapshot.docs
          .map((doc) => CategoryDTO.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar todas las categorías: $e');
    }
  }


// Obtener solo las categorías activas desde Firebase
  Future<List<CategoryDTO>> fetchActiveCategories() async {
    try {
      final querySnapshot = await _categoriesCollection
          .where('isActive', isEqualTo: true) // Filtrar por categorías activas
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryDTO.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar categorías activas: $e');
    }
  }


  // Añadir una nueva categoría
  Future<void> addCategory(CategoryDTO category) async {
    try {
      await _categoriesCollection.add(category.toJson());
    } catch (e) {
      throw Exception('Error al agregar categoría: $e');
    }
  }

  // Actualizar una categoría existente
  Future<void> updateCategory(CategoryDTO category) async {
    try {
      await _categoriesCollection.doc(category.id).update(category.toJson());
    } catch (e) {
      throw Exception('Error al actualizar categoría: $e');
    }
  }

  // Actualizar el estado activo/inactivo de una categoría
  Future<void> toggleCategoryStatus(String categoryId, bool isActive) async {
    try {
      await _categoriesCollection.doc(categoryId).update({'isActive': isActive});
    } catch (e) {
      throw Exception('Error al actualizar el estado de la categoría: $e');
    }
  }

  // Eliminar una categoría
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _categoriesCollection.doc(categoryId).delete();
    } catch (e) {
      throw Exception('Error al eliminar categoría: $e');
    }
  }
}
