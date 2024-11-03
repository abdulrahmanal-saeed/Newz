import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newz/bloc/news_bloc.dart';
import 'package:newz/views/trending_news/news_details_page.dart';
import 'package:newz/views/widgets/error_loading_indicatore.dart';
import 'package:newz/views/widgets/loading_indicatore.dart';
import 'package:timeago/timeago.dart' as timeago;

class Newsitems extends StatelessWidget {
  final String sourceId;

  const Newsitems({super.key, required this.sourceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsBloc(RepositoryProvider.of(context))
        ..add(FetchNewsBySource(sourceId)),
      child: _NewsItemsBody(sourceId: sourceId),
    );
  }
}

class _NewsItemsBody extends StatelessWidget {
  final String sourceId;

  const _NewsItemsBody({required this.sourceId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsLoading) {
          return const LoadingIndicatore();
        } else if (state is NewsError) {
          return const ErrorLoadingIndicatore();
        } else if (state is NewsLoaded) {
          final articles = state.articles;

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                context.read<NewsBloc>().add(FetchMoreNewsBySource(sourceId));
              }
              return false;
            },
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsPage(
                          category: article.source?.name ?? '',
                          title: article.title ?? 'No Title',
                          author: article.author ?? 'Unknown',
                          date: article.publishedAt?.toString() ?? 'Unknown',
                          content: article.content ?? 'No Content Available',
                          imagePath: article.urlToImage ?? '',
                          url: article.url ?? '',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article.urlToImage != null)
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl: article.urlToImage!,
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          article.title ?? 'No Title',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          article.description ?? '',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            article.publishedAt != null
                                ? timeago.format(article.publishedAt!)
                                : 'Unknown',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
