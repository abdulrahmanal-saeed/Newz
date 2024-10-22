import 'package:flutter/material.dart';
import 'package:newz/apptheme.dart';
import 'package:newz/view_models/news_view_model.dart'; // استدعاء ViewModel
import 'package:newz/views/category/catagories_gird.dart';
import 'package:newz/views/profile/profile_page.dart';
import 'package:newz/views/trending_news/trending_news_item.dart';
import 'package:newz/views/widgets/error_loading_indicatore.dart';
import 'package:newz/views/widgets/loading_indicatore.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleLarge =
        Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black);

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
              'Discover',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "AbrilFatface"),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.black),
          onPressed: () {
            // تنفيذ الإجراءات عند الضغط على الإعدادات
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => NewsViewModel()..fetchTrendingNews(),
        child: Consumer<NewsViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child:
                        CatagoriesGird(onCatagorySeleted: (catagoryModel) {}),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary, // اللون الأحمر للنقطة
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Trending News",
                        style: titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: viewModel.isLoading
                        ? const LoadingIndicatore() // حالة تحميل
                        : viewModel.hasError
                            ? const ErrorLoadingIndicatore() // حالة خطأ
                            : NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (!viewModel.isMoreLoading &&
                                      scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent) {
                                    viewModel.fetchTrendingNews(
                                        isLoadMore:
                                            true); // تحميل المزيد عند التمرير إلى الأسفل
                                  }
                                  return false;
                                },
                                child: ListView.builder(
                                  itemCount: viewModel.trendingNews.length +
                                      (viewModel.isMoreLoading ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index ==
                                            viewModel.trendingNews.length &&
                                        viewModel.isMoreLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    final article =
                                        viewModel.trendingNews[index];
                                    return TrendingNewsItem(
                                      url: article.url ?? '',
                                      imagePath: article.urlToImage ??
                                          'https://via.placeholder.com/150?text=No+Image+Available',
                                      title: article.title ?? 'No Title',
                                      category:
                                          article.source?.name ?? 'Unknown',
                                      date: article.publishedAt != null
                                          ? timeago.format(article.publishedAt!)
                                          : 'Unknown',
                                      author: article.author ?? 'Unknown',
                                      content: article.content ?? '',
                                    );
                                  },
                                ),
                              ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
