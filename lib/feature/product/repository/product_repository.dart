import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/product_dto.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(ProductDTO product) async {
    await _firestore.collection('products').doc(product.id).set(product.toMap());
  }

  Future<void> updateProduct(ProductDTO product) async {
    await _firestore.collection('products').doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  Stream<List<ProductDTO>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProductDTO.fromMap(doc.data())).toList();
    });
  }

  Future<ProductDTO?> getProductById(String productId) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
    await _firestore.collection('products').doc(productId).get();
    if (doc.exists) {
      return ProductDTO.fromMap(doc.data()!);
    }
    return null;
  }
}
