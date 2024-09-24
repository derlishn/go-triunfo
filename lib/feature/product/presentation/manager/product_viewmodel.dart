import 'package:flutter/material.dart';

import '../../data/product_dto.dart';
import '../../repository/product_repository.dart';


class ProductViewModel extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  List<ProductDTO> _products = [];

  List<ProductDTO> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    _productRepository.getProducts().listen((productList) {
      _products = productList;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addProduct(ProductDTO product) async {
    _isLoading = true;
    notifyListeners();
    await _productRepository.addProduct(product);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProduct(ProductDTO product) async {
    await _productRepository.updateProduct(product);
  }

  Future<void> deleteProduct(String productId) async {
    await _productRepository.deleteProduct(productId);
  }
}
