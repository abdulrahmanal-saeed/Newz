import 'package:flutter/material.dart';
import 'package:newz/apptheme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NewsDetailsPage extends StatelessWidget {
  final String category;
  final String title;
  final String author;
  final String date;
  final String content;
  final String imagePath;
  final String url; // الرابط الخاص بالمقال

  const NewsDetailsPage({
    super.key,
    required this.category,
    required this.title,
    required this.author,
    required this.date,
    required this.content,
    required this.imagePath,
    required this.url, // استقبال الرابط
  });

  Future<void> _launchURL(BuildContext context) async {
    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url); // تحويل الرابط إلى Uri
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri,
            mode: LaunchMode
                .externalApplication); // استخدام launchUrl بدلاً من launch
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch the URL')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No URL available')),
      );
    }
  }

  Future<void> _saveArticle(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticlesData = prefs.getStringList('savedArticles') ?? [];

    // إنشاء المقال الذي سيتم حفظه
    final articleData = jsonEncode({
      'title': title,
      'category': category,
      'author': author,
      'date': date,
      'content': content,
      'imagePath': imagePath,
      'url': url,
    });

    if (savedArticlesData.contains(articleData)) {
      // إذا كان المقال محفوظًا بالفعل، لا تقم بحفظه مرة أخرى
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This article is already saved.')),
      );
    } else {
      // حفظ المقال إذا لم يكن موجودًا
      savedArticlesData.add(articleData);
      await prefs.setStringList('savedArticles', savedArticlesData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article saved successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  // صورة الخبر
                  Image.network(
                    imagePath,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'By $author',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.5),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: IconButton(
                            icon: const Icon(Icons.bookmark_border,
                                color: AppTheme.primary),
                            onPressed: () {
                              _saveArticle(context); // حفظ المقال عند الضغط
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: IconButton(
                            icon: const Icon(Icons.share,
                                color: AppTheme.primary),
                            onPressed: () {
                              Share.share(
                                  'Check out this news: $title => $url');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // باقي المحتوى
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Published on $date',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: url.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _launchURL(context), // تمرير context هنا
              label: const Text(
                'Read Full Article',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              backgroundColor: AppTheme.primary,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
