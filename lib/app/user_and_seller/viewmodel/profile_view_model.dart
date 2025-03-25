import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_int2/app/user_and_seller/controller/userController.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {
  String profileUrl = '';
  String name = '';
  String walletBalance = '0';
  XFile? _mediaFile;
  final ImagePicker _picker = ImagePicker();

  XFile? get mediaFile => _mediaFile;

  Future<void> loadProfileData() async {
    final _prefs = await SharedPreferences.getInstance();
    profileUrl = _prefs.getString('profile') ?? '';
    name = _prefs.getString('userName') ?? '';
    notifyListeners();
  }

  Future<void> fetchWallet(String email) async {
    var response = await UserController.fetchWallet(email);
    walletBalance = response.isEmpty ? '0' : response;
    notifyListeners();
  }

  Future<void> pickImage() async {
    _mediaFile = await _picker.pickImage(
      imageQuality: 70,
      source: ImageSource.gallery,
    );
    if (_mediaFile != null) {
      await UserController.uploadUserProfile(
          base64Encode(File(_mediaFile!.path).readAsBytesSync()));
      notifyListeners();
    }
  }
}
