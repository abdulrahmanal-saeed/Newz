import 'package:flutter/material.dart';
import 'package:newz/apptheme.dart';
import 'package:newz/views/trending_news/news_details_page.dart'; // استيراد صفحة NewsDetailsPage
// مكتبة timeago لتحويل التواريخ

class TrendingNewsItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String category;
  final String date;
  final String url; // رابط المقال
  final String author; // إضافة الكاتب
  final String content; // إضافة المحتوى

  const TrendingNewsItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.category,
    required this.date,
    required this.url, // تمرير الرابط هنا
    required this.author, // تمرير الكاتب
    required this.content, // تمرير المحتوى
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // نقل المستخدم إلى صفحة NewsDetailsPage عند الضغط على المقال
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailsPage(
              category: category,
              title: title,
              author: author,
              date: date,
              content: content,
              imagePath: imagePath,
              url: url, // تمرير الرابط ليتم فتحه في الصفحة
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppTheme.lightGray,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imagePath,
                  width: 100.0,
                  height: 80.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGray,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      date,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
