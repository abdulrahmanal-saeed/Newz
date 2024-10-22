import 'package:flutter/material.dart';
import 'package:newz/views/trending_news/news_details_page.dart';
import 'package:newz/views/widgets/error_loading_indicatore.dart';
import 'package:newz/views/widgets/loading_indicatore.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:newz/view_models/news_view_model.dart';

class Newsitems extends StatelessWidget {
  final String sourceId;

  const Newsitems({super.key, required this.sourceId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsViewModel()..fetchNewsBySource(sourceId),
      child: _NewsItemsBody(sourceId: sourceId),
    );
  }
}

class _NewsItemsBody extends StatelessWidget {
  final String sourceId;

  const _NewsItemsBody({required this.sourceId});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NewsViewModel>(context);

    if (viewModel.isLoading) {
      return const LoadingIndicatore();
    } else if (viewModel.hasError) {
      return const ErrorLoadingIndicatore();
    }

    final articles = viewModel.articles;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!viewModel.isMoreLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          viewModel
              .fetchMoreNewsBySource(sourceId); // تأكد من تمرير sourceId هنا
        }
        return false;
      },
      child: ListView.builder(
        itemCount: articles.length + (viewModel.isMoreLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == articles.length && viewModel.isMoreLoading) {
            return const Center(child: CircularProgressIndicator());
          }

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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.network(
                        article.urlToImage!,
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
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
}
