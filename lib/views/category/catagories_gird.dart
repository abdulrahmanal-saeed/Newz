import 'package:flutter/material.dart';
import 'package:newz/apptheme.dart';
import 'package:newz/data/category_data.dart'; // استيراد ملف البيانات
import 'package:newz/views/category/catagory_item.dart';
import 'package:newz/models/catagory_model.dart';
import 'package:newz/views/category/categorydetail.dart';

class CatagoriesGird extends StatelessWidget {
  const CatagoriesGird({super.key, required this.onCatagorySeleted});

  final void Function(CatagoryModel) onCatagorySeleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Categories",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      onCatagorySeleted(category);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetail(
                            categoryId: category.id,
                            categoryName: category.categoryName,
                          ),
                        ),
                      );
                    },
                    child: CatagoryItem(
                      category: category,
                      index: index,
                      isSelected: false, // يمكنك التحكم في حالة التحديد إذا لزم
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
