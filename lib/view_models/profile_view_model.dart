import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {
  String name = '';
  String email = '';
  String profileImagePath = '';
  bool isLoading = false;
  bool hasError = false;

  Future<void> loadProfileData() async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      profileImagePath = prefs.getString('profileImagePath') ?? '';
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      notifyListeners();
    }
  }

  Future<void> saveProfileData(
      String newName, String newEmail, String newImagePath) async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', newName);
      await prefs.setString('email', newEmail);
      await prefs.setString('profileImagePath', newImagePath);

      name = newName;
      email = newEmail;
      profileImagePath = newImagePath;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      notifyListeners();
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    // هنا يمكنك إضافة منطق تغيير كلمة المرور
    // على سبيل المثال، التحقق من كلمة المرور الحالية
    // وتحديث كلمة المرور الجديدة
    // بعد النجاح، يمكنك عرض رسالة بنجاح العملية
  }
}
