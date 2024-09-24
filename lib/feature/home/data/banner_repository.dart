import 'package:cloud_firestore/cloud_firestore.dart';
import 'banner_dto.dart';

class BannerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Colección de banners en Firestore
  CollectionReference get _bannersCollection =>
      _firestore.collection('banners');

  // Obtener todos los banners
  Future<List<BannerDTO>> fetchBanners() async {
    try {
      final querySnapshot = await _bannersCollection.get();
      return querySnapshot.docs
          .map((doc) => BannerDTO.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar banners: $e');
    }
  }

  // Añadir un nuevo banner
  Future<void> addBanner(BannerDTO banner) async {
    try {
      await _bannersCollection.add(banner.toJson());
    } catch (e) {
      throw Exception('Error al agregar banner: $e');
    }
  }

  // Actualizar un banner existente
  Future<void> updateBanner(BannerDTO banner) async {
    try {
      await _bannersCollection.doc(banner.id).update(banner.toJson());
    } catch (e) {
      throw Exception('Error al actualizar banner: $e');
    }
  }

  // Eliminar un banner
  Future<void> deleteBanner(String bannerId) async {
    try {
      await _bannersCollection.doc(bannerId).delete();
    } catch (e) {
      throw Exception('Error al eliminar banner: $e');
    }
  }
}
