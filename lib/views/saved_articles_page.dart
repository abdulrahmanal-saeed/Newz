import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newz/apptheme.dart';
import 'package:newz/bloc/saved_articles/saved_articles_bloc.dart';
import 'package:newz/bloc/saved_articles/saved_articles_event.dart';
import 'package:newz/bloc/saved_articles/saved_articles_state.dart';
import 'package:newz/repositories/saved-articles_repository.dart';
import 'package:newz/views/trending_news/news_details_page.dart';

class SavedArticlesPage extends StatelessWidget {
  const SavedArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedArticlesBloc(
        RepositoryProvider.of<SavedArticlesRepository>(context),
      )..add(LoadSavedArticles()),
      child: Scaffold(
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
            BlocBuilder<SavedArticlesBloc, SavedArticlesState>(
              builder: (context, state) {
                if (state is SavedArticlesLoaded) {
                  return IconButton(
                    icon: Icon(state.isEditMode ? Icons.check : Icons.edit),
                    onPressed: () {
                      BlocProvider.of<SavedArticlesBloc>(context)
                          .add(LoadSavedArticles());
                    },
                  );
                }
                return Container();
              },
            ),
          ],
        ),
        body: BlocBuilder<SavedArticlesBloc, SavedArticlesState>(
          builder: (context, state) {
            if (state is SavedArticlesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SavedArticlesLoaded) {
              if (state.articles.isEmpty) {
                return const Center(child: Text("No saved articles found."));
              }

              return Column(
                children: [
                  if (state.isEditMode)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CheckboxListTile(
                        title: const Text("Select All"),
                        value: state.isAllSelected,
                        onChanged: (value) {
                          // إرسال حدث لتحديد الكل
                        },
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.articles.length,
                      itemBuilder: (context, index) {
                        final article = state.articles[index];
                        return Card(
                          margin: const EdgeInsets.all(12.0),
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10.0),
                            leading: state.isEditMode
                                ? Checkbox(
                                    value: state.selectedArticles[index],
                                    onChanged: (value) {
                                      // تحديث حالة التحديد لهذا المقال
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
                            onTap: !state.isEditMode
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsDetailsPage(
                                          category: article['category'] ?? '',
                                          title: article['title'] ?? '',
                                          author:
                                              article['author'] ?? 'Unknown',
                                          date: article['date'] ?? '',
                                          content: article['content'] ??
                                              'No content available.',
                                          imagePath: article['imagePath'] ?? '',
                                          url: article['url'] ?? '',
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  if (state.isEditMode)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete Selected"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        onPressed: state.selectedArticles.contains(true)
                            ? () {
                                BlocProvider.of<SavedArticlesBloc>(context).add(
                                  DeleteSelectedArticles(
                                      state.selectedArticles),
                                );
                              }
                            : null,
                      ),
                    ),
                ],
              );
            } else if (state is SavedArticlesError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
