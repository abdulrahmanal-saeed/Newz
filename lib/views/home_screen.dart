import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newz/apptheme.dart';
import 'package:newz/bloc/news_bloc.dart';
import 'package:newz/views/category/catagories_gird.dart';
import 'package:newz/views/saved_articles_page.dart';
import 'package:newz/views/trending_news/trending_news_item.dart';
import 'package:newz/views/widgets/error_loading_indicatore.dart';
import 'package:newz/views/widgets/loading_indicatore.dart';
import 'package:newz/views/widgets/search_results_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

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
          icon: const Icon(Icons.contact_support, color: Colors.black),
          onPressed: () async {
            const String phone = '+971585829128';
            const String message =
                'Hello! I have a question about the newz app. Can you help me?';
            final String whatsappUrl =
                'whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}';

            if (await canLaunch(whatsappUrl)) {
              await launch(whatsappUrl);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("WhatsApp is not installed on your device."),
                ),
              );
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.article_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SavedArticlesPage()),
              );
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            NewsBloc(RepositoryProvider.of(context))..add(FetchTrendingNews()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: searchController,
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchResultsPage(query: query)),
                    );
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      final query = searchController.text.trim();
                      if (query.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SearchResultsPage(query: query)),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: CatagoriesGird(onCatagorySeleted: (catagoryModel) {}),
              ),
              const SizedBox(height: 16.0),
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
                    "Trending News",
                    style: titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if (state is NewsLoading) {
                      return const LoadingIndicatore();
                    } else if (state is NewsError) {
                      return const ErrorLoadingIndicatore();
                    } else if (state is NewsLoaded) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            context
                                .read<NewsBloc>()
                                .add(FetchMoreTrendingNews());
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount: state.articles.length,
                          itemBuilder: (context, index) {
                            final article = state.articles[index];
                            return TrendingNewsItem(
                              url: article.url ?? '',
                              imagePath: article.urlToImage ??
                                  'https://via.placeholder.com/150?text=No+Image+Available',
                              title: article.title ?? 'No Title',
                              category: article.source?.name ?? 'Unknown',
                              date:
                                  article.publishedAt?.toString() ?? 'Unknown',
                              author: article.author ?? 'Unknown',
                              content: article.content ?? '',
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
