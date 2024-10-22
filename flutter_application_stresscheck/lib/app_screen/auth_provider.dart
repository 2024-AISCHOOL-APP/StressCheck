import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _userName;  // user_name 저장

  bool get isLoggedIn => _userId != null;
  String? get userId => _userId;
  String? get userName => _userName;  // user_name 가져오기

  void login(String userId, String userName) {
    _userId = userId;
    _userName = userName;  // user_name 저장
    notifyListeners();
  }

  void logout() {
    _userId = null;
    _userName = null;  // 로그아웃 시 user_name 초기화
    notifyListeners();
  }
}
