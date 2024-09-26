import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'business_dto.dart';
import 'business_repository.dart';

class BusinessViewModel extends ChangeNotifier {
  final BusinessRepository _businessRepository;

  // Estado de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Lista de negocios
  List<BusinessDTO> _businesses = [];
  List<BusinessDTO> get businesses => _businesses;

  // Lista de negocios activos
  List<BusinessDTO> _activeBusinesses = [];
  List<BusinessDTO> get activeBusinesses => _activeBusinesses;

  // Mensaje de error en caso de que algo salga mal
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Paginación
  bool _hasMoreBusinesses = true;
  bool get hasMoreBusinesses => _hasMoreBusinesses;

  DocumentSnapshot? _lastDocument;

  BusinessViewModel({BusinessRepository? businessRepository})
      : _businessRepository = businessRepository ?? BusinessRepository();

  // Obtener negocios con paginación
  Future<void> fetchBusinesses({int limit = 6}) async {
    if (!_hasMoreBusinesses || _isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final querySnapshot = await _businessRepository.fetchBusinesses(
        limit: limit,
        startAfter: _lastDocument,
      );

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last; // DocumentSnapshot para la paginación

        final newBusinesses = querySnapshot.docs.map((doc) {
          return BusinessDTO.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        _businesses.addAll(newBusinesses);
      } else {
        _hasMoreBusinesses = false;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtener todos los negocios (limpiar lista antes de agregar)
  Future<void> fetchAllBusinesses({int limit = 6}) async {
    _isLoading = true;
    _errorMessage = null;
    _businesses.clear(); // Limpiar la lista antes de cargar nuevos datos
    notifyListeners();

    try {
      final querySnapshot = await _businessRepository.fetchBusinesses(limit: limit);
      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last; // Guardar el último documento para la paginación

        final newBusinesses = querySnapshot.docs.map((doc) {
          return BusinessDTO.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        _businesses = newBusinesses; // Reemplazar la lista existente
      } else {
        _hasMoreBusinesses = false;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtener solo negocios activos (para el home)
  Future<void> fetchActiveBusinesses({int limit = 6}) async {
    _isLoading = true;
    _errorMessage = null;
    _activeBusinesses.clear(); // Limpiar la lista de activos antes de cargar nuevos datos
    notifyListeners();

    try {
      final querySnapshot = await _businessRepository.fetchActiveBusinesses(limit: limit);

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;

        final newActiveBusinesses = querySnapshot.docs.map((doc) {
          return BusinessDTO.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        _activeBusinesses = newActiveBusinesses; // Reemplazar la lista de activos
      } else {
        _hasMoreBusinesses = false;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Añadir un nuevo negocio
  Future<void> addBusiness({
    required String name,
    required String ownerName,
    required String ownerEmail,
    required String ownerPhone,
    required String address,
    required String businessPhone,
    required String imageUrl,
    required String categoryId,
    String? description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newBusiness = BusinessDTO(
        id: '', // ID se generará en Firestore
        name: name,
        ownerName: ownerName,
        ownerEmail: ownerEmail,
        ownerPhone: ownerPhone,
        address: address,
        businessPhone: businessPhone,
        imageUrl: imageUrl,
        categoryId: categoryId,
        isActive: true,
        ordersToday: 0,
        createdAt: DateTime.now(),
        monthlyOrders: {},
        weeklyOrders: {},
        totalProducts: 0,
        description: description,
      );
      await _businessRepository.addBusiness(newBusiness);
      await fetchAllBusinesses(); // Refrescar la lista después de añadir
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar un negocio existente (actualizar directamente el negocio en la lista)
  Future<void> updateBusiness(BusinessDTO business) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _businessRepository.updateBusiness(business);
      _businesses = _businesses.map((b) => b.id == business.id ? business : b).toList();
      notifyListeners(); // Notificar solo el cambio local sin recargar todos los negocios
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Eliminar un negocio (actualizar la lista local)
  Future<void> deleteBusiness(String businessId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _businessRepository.deleteBusiness(businessId);
      _businesses.removeWhere((b) => b.id == businessId); // Eliminar localmente
      notifyListeners(); // Notificar solo el cambio local
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Cambiar el estado de activación de un negocio (actualizar directamente)
  Future<void> toggleBusinessStatus(String businessId, bool isActive) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _businessRepository.toggleBusinessStatus(businessId, isActive);
      _businesses = _businesses.map((b) {
        if (b.id == businessId) {
          return b.copyWith(isActive: isActive);
        }
        return b;
      }).toList(); // Actualizar el estado localmente sin recargar todos los negocios
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Restablecer el error
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  // Restablecer la paginación y limpiar listas
  void resetPagination() {
    _businesses.clear();
    _activeBusinesses.clear();
    _lastDocument = null;
    _hasMoreBusinesses = true;
    notifyListeners();
  }
}
