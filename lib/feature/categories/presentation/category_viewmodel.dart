import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/category_dto.dart';
import '../data/category_repository.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryRepository _categoryRepository;



  // Estado de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Lista de categorías
  List<CategoryDTO> _categories = [];
  List<CategoryDTO> get categories => _categories;

  // Mensaje de error en caso de que algo salga mal
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Paginación
  bool _hasMoreCategories = true;
  bool get hasMoreCategories => _hasMoreCategories;

  DocumentSnapshot? _lastDocument;

  CategoryViewModel({CategoryRepository? categoryRepository})
      : _categoryRepository = categoryRepository ?? CategoryRepository() {
    fetchActiveCategories();
  }


  // Obtener categorías con paginación
  Future<void> fetchCategories({int limit = 6}) async {
    if (!_hasMoreCategories || _isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final querySnapshot = await _categoryRepository.fetchCategories(
        limit: limit,
        startAfter: _lastDocument,
      );

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last; // DocumentSnapshot para la paginación

        final newCategories = querySnapshot.docs.map((doc) {
          return CategoryDTO.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        _categories.addAll(newCategories);
      } else {
        _hasMoreCategories = false;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtener todas las categorías activas (sin paginación)
  Future<void> fetchActiveCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Ahora llamamos a `fetchActiveCategories` en lugar de `fetchAllCategories`
      _categories = await _categoryRepository.fetchActiveCategories();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Añadir una nueva categoría
  Future<void> addCategory(String name, {String? icon}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newCategory = CategoryDTO(
        id: '', // ID se generará en Firestore
        name: name,
        icon: icon ?? '📦',
        isActive: true, // Nueva categoría siempre activa por defecto
      );
      await _categoryRepository.addCategory(newCategory);
      await  fetchActiveCategories(); // Refrescar la lista después de añadir
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar una categoría existente
  Future<void> updateCategory(CategoryDTO category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _categoryRepository.updateCategory(category);
      await  fetchActiveCategories();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eliminar una categoría
  Future<void> deleteCategory(String categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _categoryRepository.deleteCategory(categoryId);
      await  fetchActiveCategories();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtener todas las categorías, incluidas las desactivadas
  Future<void> fetchAllCategoriesIncludingInactive() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _categoryRepository.fetchAllCategoriesIncludingInactive();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Activar/Desactivar categoría y recargar solo categorías activas
  Future<void> toggleCategoryStatus(String categoryId, bool isActive) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _categoryRepository.toggleCategoryStatus(categoryId, isActive);
      await fetchActiveCategories();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Método para restablecer el mensaje de error
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  // Restablecer la paginación para comenzar desde la primera categoría
  void resetPagination() {
    _categories.clear();
    _lastDocument = null;
    _hasMoreCategories = true;
  }
}
