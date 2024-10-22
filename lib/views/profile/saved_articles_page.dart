import 'package:flutter/material.dart';
import 'package:newz/apptheme.dart';
import 'package:newz/views/trending_news/news_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // لتحليل المقالات المحفوظة من JSON

class SavedArticlesPage extends StatefulWidget {
  const SavedArticlesPage({super.key});

  @override
  _SavedArticlesPageState createState() => _SavedArticlesPageState();
}

class _SavedArticlesPageState extends State<SavedArticlesPage> {
  List<dynamic> savedArticles = [];
  List<bool> selectedArticles = []; // لتحديد المقالات المختارة للحذف
  bool isEditMode = false; // للتحكم في وضع التعديل
  bool isAllSelected = false; // للتحكم في حالة "تحديد الكل"

  @override
  void initState() {
    super.initState();
    _loadSavedArticles(); // تحميل المقالات المحفوظة عند تهيئة الصفحة
  }

  Future<void> _loadSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticlesData = prefs.getStringList('savedArticles') ?? [];

    setState(() {
      savedArticles = savedArticlesData
          .map((articleJson) => jsonDecode(articleJson))
          .toList();
      selectedArticles = List<bool>.filled(savedArticles.length,
          false); // تعيين قيم أولية لجميع المقالات كـ "غير مختارة"
    });
  }

  // دالة لحذف المقالات المختارة
  Future<void> _deleteSelectedArticles() async {
    setState(() {
      savedArticles = [
        for (int i = 0; i < savedArticles.length; i++)
          if (!selectedArticles[i]) savedArticles[i]
      ];
      selectedArticles = List<bool>.filled(savedArticles.length, false);
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('savedArticles',
        savedArticles.map((article) => jsonEncode(article)).toList());

    setState(() {
      isEditMode = false; // الخروج من وضع التعديل بعد الحذف
    });
  }

  // دالة لتحديد أو إلغاء تحديد الكل
  void _selectAllArticles(bool value) {
    setState(() {
      isAllSelected = value;
      selectedArticles = List<bool>.filled(savedArticles.length, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'Saved Articles',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "AbrilFatface"),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppTheme.darkGray),
        actions: [
          // زر تعديل لبدء وضع الحذف
          IconButton(
            icon: Icon(isEditMode ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
          ),
        ],
      ),
      body: savedArticles.isEmpty
          ? const Center(child: Text("No saved articles found."))
          : Column(
              children: [
                if (isEditMode)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CheckboxListTile(
                      title: const Text("Select All"),
                      value: isAllSelected,
                      onChanged: (value) {
                        _selectAllArticles(value!); // تحديد/إلغاء تحديد الكل
                      },
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: savedArticles.length,
                    itemBuilder: (context, index) {
                      final article = savedArticles[index];
                      return Card(
                        margin: const EdgeInsets.all(12.0),
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10.0),
                          leading: isEditMode
                              ? Checkbox(
                                  value: selectedArticles[index],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedArticles[index] = value!;
                                    });
                                  },
                                )
                              : article['imagePath'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        article['imagePath'],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(Icons.article, size: 80),
                          title: Text(
                            article['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            article['category'] ?? 'Unknown Category',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          onTap: !isEditMode
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailsPage(
                                        category: article['category'] ?? '',
                                        title: article['title'] ?? '',
                                        author: article['author'] ?? 'Unknown',
                                        date: article['date'] ?? '',
                                        content: article['content'] ??
                                            'No content available.',
                                        imagePath: article['imagePath'] ?? '',
                                        url: article['url'] ?? '',
                                      ),
                                    ),
                                  );
                                }
                              : null, // عند وضع التعديل، لن يتم الانتقال
                        ),
                      );
                    },
                  ),
                ),
                if (isEditMode)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete Selected"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: selectedArticles.contains(true)
                          ? _deleteSelectedArticles
                          : null, // تفعيل الزر فقط عند وجود مقالات مختارة
                    ),
                  ),
              ],
            ),
    );
  }
}
