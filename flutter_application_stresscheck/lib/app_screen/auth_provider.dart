import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _userName;  // user_name 저장
  String? _userGender;  // user_gender 저장
  String? _userBirthdate;  // user_birthdate 저장
  String? _userJob;  // user_job 저장
  int? _userSleep;  // user_sleep 저장

  bool get isLoggedIn => _userId != null;
  String? get userId => _userId;
  String? get userName => _userName;  
  String? get userGender => _userGender;
  String? get userBirthdate => _userBirthdate;
  String? get userJob => _userJob;
  int? get userSleep => _userSleep;

  void login(String userId, String userName, String userGender, String userBirthdate, String userJob, int userSleep) {
    _userId = userId;
    _userName = userName;
    _userGender = userGender;
    _userBirthdate = userBirthdate;
    _userJob = userJob;
    _userSleep = userSleep;
    notifyListeners();
  }

  // 정보 수정 시 사용자 정보를 업데이트
  void updateUserDetails(String userGender, String userBirthdate, String userJob, int userSleep) {
    _userGender = userGender;
    _userBirthdate = userBirthdate;
    _userJob = userJob;
    _userSleep = userSleep;
    notifyListeners();
  }

  void logout() {
    _userId = null;
    _userName = null;
    _userGender = null;
    _userBirthdate = null;
    _userJob = null;
    _userSleep = null;
    notifyListeners();
  }
}
