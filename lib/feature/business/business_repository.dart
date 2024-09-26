import 'package:cloud_firestore/cloud_firestore.dart';
import 'business_dto.dart';

class BusinessRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Colección de negocios en Firestore
  CollectionReference get _businessCollection =>
      _firestore.collection('businesses');

  // Obtener todos los negocios activos con paginación
  Future<QuerySnapshot> fetchActiveBusinesses({int limit = 6, DocumentSnapshot? startAfter}) async {
    try {
      Query query = _businessCollection
          .where('isActive', isEqualTo: true) // Solo negocios activos
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      return await query.get();
    } catch (e) {
      throw Exception('Error al cargar negocios activos: $e');
    }
  }

  // Método general para obtener negocios con opción de filtrado por estado activo
  Future<QuerySnapshot> fetchBusinesses({
    int limit = 6,
    DocumentSnapshot? startAfter,
    bool? isActive, // Parámetro opcional para filtrar por estado activo
  }) async {
    try {
      Query query = _businessCollection.orderBy('createdAt', descending: true).limit(limit);

      // Filtrar por estado activo si se proporciona
      if (isActive != null) {
        query = query.where('isActive', isEqualTo: isActive);
      }

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      return await query.get();
    } catch (e) {
      throw Exception('Error al cargar negocios: $e');
    }
  }

  // Obtener todos los negocios sin paginación
  Future<List<BusinessDTO>> fetchAllBusinesses({bool? isActive}) async {
    try {
      Query query = _businessCollection;

      // Filtrar por estado activo si se proporciona
      if (isActive != null) {
        query = query.where('isActive', isEqualTo: isActive);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => BusinessDTO.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar negocios: $e');
    }
  }

  // Obtener un negocio por ID
  Future<BusinessDTO> fetchBusinessById(String id) async {
    try {
      final docSnapshot = await _businessCollection.doc(id).get();
      if (docSnapshot.exists) {
        return BusinessDTO.fromJson(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      } else {
        throw Exception('Negocio no encontrado');
      }
    } catch (e) {
      throw Exception('Error al cargar negocio: $e');
    }
  }

  // Añadir un nuevo negocio
  Future<void> addBusiness(BusinessDTO business) async {
    try {
      await _businessCollection.add(business.toJson());
    } catch (e) {
      throw Exception('Error al agregar negocio: $e');
    }
  }

  // Actualizar un negocio existente
  Future<void> updateBusiness(BusinessDTO business) async {
    try {
      await _businessCollection.doc(business.id).update(business.toJson());
    } catch (e) {
      throw Exception('Error al actualizar negocio: $e');
    }
  }

  // Eliminar un negocio por ID
  Future<void> deleteBusiness(String businessId) async {
    try {
      await _businessCollection.doc(businessId).delete();
    } catch (e) {
      throw Exception('Error al eliminar negocio: $e');
    }
  }

  // Actualizar el estado (activo/inactivo) de un negocio
  Future<void> toggleBusinessStatus(String businessId, bool isActive) async {
    try {
      await _businessCollection.doc(businessId).update({'isActive': isActive});
    } catch (e) {
      throw Exception('Error al cambiar el estado del negocio: $e');
    }
  }

  // Actualizar los pedidos diarios de un negocio
  Future<void> updateOrdersToday(String businessId, int newOrderCount) async {
    try {
      await _businessCollection.doc(businessId).update({'ordersToday': newOrderCount});
    } catch (e) {
      throw Exception('Error al actualizar pedidos diarios: $e');
    }
  }

  // Actualizar los pedidos mensuales y semanales de un negocio
  Future<void> updateMonthlyAndWeeklyOrders(String businessId, DateTime date) async {
    try {
      final businessSnapshot = await _businessCollection.doc(businessId).get();
      if (businessSnapshot.exists) {
        final business = BusinessDTO.fromJson(
          businessSnapshot.data() as Map<String, dynamic>,
          businessSnapshot.id,
        );

        business.updateMonthlyOrders(date);
        business.updateWeeklyOrders(date);

        await _businessCollection.doc(business.id).update({
          'monthlyOrders': business.monthlyOrders,
          'weeklyOrders': business.weeklyOrders,
        });
      } else {
        throw Exception('Negocio no encontrado para actualizar pedidos');
      }
    } catch (e) {
      throw Exception('Error al actualizar pedidos mensuales y semanales: $e');
    }
  }

  // Buscar negocios por nombre o parte del nombre
  Future<List<BusinessDTO>> searchBusinessesByName(String name) async {
    try {
      final querySnapshot = await _businessCollection
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThanOrEqualTo: '$name\uf8ff') // Para búsqueda parcial
          .get();

      return querySnapshot.docs
          .map((doc) => BusinessDTO.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar negocios: $e');
    }
  }
}
