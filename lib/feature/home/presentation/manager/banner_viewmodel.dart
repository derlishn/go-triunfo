import 'package:flutter/material.dart';
import '../../data/banner_dto.dart';
import '../../data/banner_repository.dart';

class BannerViewModel extends ChangeNotifier {
  final BannerRepository _bannerRepository = BannerRepository();

  bool _isLoading = false;
  String? _errorMessage;
  List<BannerDTO> _banners = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<BannerDTO> get banners => _banners;
  List<BannerDTO> get activeBanners => _banners.where((banner) => banner.isActive).toList();

  // Fetch banners from Firebase
  Future<void> fetchBanners() async {
    _setLoading(true);
    try {
      _banners = await _bannerRepository.fetchBanners();
    } catch (e) {
      _setErrorMessage('Error fetching banners: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Añadir un nuevo banner
  Future<void> addBanner(String title, String imageUrl) async {
    _setLoading(true);
    try {
      final newBanner = BannerDTO(
        id: '',  // ID generado por Firebase
        title: title,
        imageUrl: imageUrl,
        isActive: true, // Por defecto, el nuevo banner está activo
      );
      await _bannerRepository.addBanner(newBanner);
      await fetchBanners();  // Refrescar la lista de banners
    } catch (e) {
      _setErrorMessage('Error al agregar banner: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar un banner existente
  Future<void> updateBanner(BannerDTO banner) async {
    _setLoading(true);
    try {
      await _bannerRepository.updateBanner(banner);
      await fetchBanners();  // Refrescar la lista después de la actualización
    } catch (e) {
      _setErrorMessage('Error al actualizar banner: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Cambiar el estado activo/inactivo de un banner
  Future<void> toggleBannerStatus(BannerDTO banner) async {
    _setLoading(true);
    try {
      final updatedBanner = banner.copyWith(isActive: !banner.isActive);
      await _bannerRepository.updateBanner(updatedBanner);
      await fetchBanners();  // Refrescar la lista después de cambiar el estado
    } catch (e) {
      _setErrorMessage('Error al cambiar el estado del banner: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Eliminar un banner
  Future<void> deleteBanner(String bannerId) async {
    _setLoading(true);
    try {
      await _bannerRepository.deleteBanner(bannerId);
      await fetchBanners();  // Refrescar la lista después de eliminar
    } catch (e) {
      _setErrorMessage('Error al eliminar banner: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Set error message
  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Clear error message
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
