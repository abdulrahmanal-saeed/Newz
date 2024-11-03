import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newz/bloc/news_bloc.dart';
import 'package:newz/views/widgets/loading_indicatore.dart';
import 'package:newz/views/widgets/error_loading_indicatore.dart';
import 'package:newz/views/trending_news/trending_news_item.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;

  const SearchResultsPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$query"'),
      ),
      body: BlocProvider(
        create: (context) => NewsBloc(RepositoryProvider.of(context))
          ..add(SearchNewsEvent(query)),
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const LoadingIndicatore();
            } else if (state is NewsError) {
              return const ErrorLoadingIndicatore();
            } else if (state is NewsLoaded) {
              return ListView.builder(
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  final article = state.articles[index];
                  return TrendingNewsItem(
                    url: article.url ?? '',
                    imagePath: article.urlToImage ??
                        'https://via.placeholder.com/150?text=No+Image+Available',
                    title: article.title ?? 'No Title',
                    category: article.source?.name ?? 'Unknown',
                    date: article.publishedAt?.toString() ?? 'Unknown',
                    author: article.author ?? 'Unknown',
                    content: article.content ?? '',
                  );
                },
              );
            }
            return const Center(child: Text("No results found."));
          },
        ),
      ),
    );
  }
}
