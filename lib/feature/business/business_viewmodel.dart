import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'business_dto.dart';

class BusinessViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<BusinessDTO> businesses = [];
  bool isLoading = false;

  Future<void> fetchBusinesses() async {
    isLoading = true;
    notifyListeners();

    final querySnapshot = await _firestore.collection('businesses').get();
    businesses = querySnapshot.docs
        .map((doc) => BusinessDTO.fromMap(doc.data()))
        .toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addBusiness(BusinessDTO business) async {
    final docRef = _firestore.collection('businesses').doc();
    final newBusiness = business.copyWith(id: docRef.id);
    await docRef.set(newBusiness.toMap());
    businesses.add(newBusiness);
    notifyListeners();
  }

  Future<void> deleteBusiness(String businessId) async {
    await _firestore.collection('businesses').doc(businessId).delete();
    businesses.removeWhere((business) => business.id == businessId);
    notifyListeners();
  }
}
