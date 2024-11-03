import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newz/bloc/saved_articles/saved_articles_event.dart';
import 'package:newz/bloc/saved_articles/saved_articles_state.dart';
import 'package:newz/repositories/saved-articles_repository.dart';

class SavedArticlesBloc extends Bloc<SavedArticlesEvent, SavedArticlesState> {
  final SavedArticlesRepository repository;

  SavedArticlesBloc(this.repository) : super(SavedArticlesLoading()) {
    on<LoadSavedArticles>(_onLoadSavedArticles);
    on<DeleteSelectedArticles>(_onDeleteSelectedArticles);
  }

  Future<void> _onLoadSavedArticles(
      LoadSavedArticles event, Emitter<SavedArticlesState> emit) async {
    try {
      emit(SavedArticlesLoading());
      final articles = await repository.loadSavedArticles();
      emit(SavedArticlesLoaded(
        articles: articles,
        selectedArticles: List<bool>.filled(articles.length, false),
      ));
    } catch (e) {
      emit(SavedArticlesError("Failed to load saved articles."));
    }
  }

  Future<void> _onDeleteSelectedArticles(
      DeleteSelectedArticles event, Emitter<SavedArticlesState> emit) async {
    if (state is SavedArticlesLoaded) {
      final currentState = state as SavedArticlesLoaded;
      final updatedArticles = [
        for (int i = 0; i < currentState.articles.length; i++)
          if (!event.selectedArticles[i]) currentState.articles[i]
      ];
      await repository.saveArticles(updatedArticles);
      emit(SavedArticlesLoaded(
        articles: updatedArticles,
        selectedArticles: List<bool>.filled(updatedArticles.length, false),
      ));
    }
  }
}
