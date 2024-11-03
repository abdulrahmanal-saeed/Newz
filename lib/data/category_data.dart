import 'package:flutter/material.dart';
import 'package:newz/models/catagory_model.dart';

const List<CatagoryModel> categories = [
  CatagoryModel(
    id: "sports",
    categoryName: "Sports",
    gradientColors: [Color(0xFF43CBFF), Color(0xFF9708CC)],
    imageName: 'ball',
  ),
  CatagoryModel(
    id: "technology",
    categoryName: "Technology",
    gradientColors: [Color(0xFFFBAB66), Color(0xFFF7418C)],
    imageName: 'Politics',
  ),
  CatagoryModel(
    id: "health",
    categoryName: "Health",
    gradientColors: [Color(0xFF9B86F1), Color(0xFF4A3EA3)],
    imageName: 'health',
  ),
  CatagoryModel(
    id: "business",
    categoryName: "Business",
    gradientColors: [Color(0xFFFFD34D), Color(0xFFE93C3C)],
    imageName: 'bussines',
  ),
  CatagoryModel(
    id: "science",
    categoryName: "Science",
    gradientColors: [Color(0xFF6EE2F5), Color(0xFF6454F0)],
    imageName: 'science',
  ),
];
