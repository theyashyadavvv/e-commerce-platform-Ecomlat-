import 'package:flutter/material.dart';

class UserSellerViewModel extends ChangeNotifier {
  String _userName = '';
  String _email = '';
  bool _isLoading = false;

  // Getters
  String get userName => _userName;
  String get email => _email;
  bool get isLoading => _isLoading;

  // Setters with notifyListeners to update the UI
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setEmail(String userEmail) {
    _email = userEmail;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Simulate API call for fetching user data
  Future<void> fetchUserData() async {
    setLoading(true);
    await Future.delayed(Duration(seconds: 2)); // Simulating network delay
    setUserName("John Doe");
    setEmail("john.doe@example.com");
    setLoading(false);
  }
}
