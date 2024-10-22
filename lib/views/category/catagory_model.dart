import 'package:flutter/material.dart';

class CatagoryModel {
  final String id;
  final String categoryName;
  final List<Color> gradientColors; // تغيير الألوان إلى تدرجات لونية
  final String imageName;

  const CatagoryModel({
    required this.id,
    required this.categoryName,
    required this.gradientColors, // تدرجات لونية
    required this.imageName,
  });
}
