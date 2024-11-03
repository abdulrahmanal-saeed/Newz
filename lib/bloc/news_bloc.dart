import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newz/models/news_resbones/article.dart';
import 'package:newz/repositories/news_repository.dart';

abstract class NewsEvent {}

class FetchNewsByCategory extends NewsEvent {
  final String category;
  FetchNewsByCategory(this.category);
}

class FetchNewsBySource extends NewsEvent {
  final String sourceId;
  FetchNewsBySource(this.sourceId);
}

class FetchMoreNewsBySource extends NewsEvent {
  final String sourceId;
  FetchMoreNewsBySource(this.sourceId);
}

class FetchTrendingNews extends NewsEvent {}

class FetchMoreTrendingNews extends NewsEvent {}

class SearchNewsEvent extends NewsEvent {
  final String query;
  SearchNewsEvent(this.query);
}

abstract class NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Article> articles;
  NewsLoaded(this.articles);
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;
  int currentPage = 1;
  List<Article> allArticles = [];

  NewsBloc(this.newsRepository) : super(NewsLoading()) {
    on<FetchNewsByCategory>((event, emit) async {
      emit(NewsLoading());
      try {
        final articles =
            await newsRepository.fetchNewsByCategory(event.category);
        allArticles = articles;
        emit(NewsLoaded(articles));
      } catch (e) {
        emit(NewsError("Failed to fetch news by category"));
      }
    });

    on<FetchNewsBySource>((event, emit) async {
      emit(NewsLoading());
      try {
        final articles = await newsRepository.fetchNewsBySource(event.sourceId);
        allArticles = articles!;
        emit(NewsLoaded(articles));
      } catch (e) {
        emit(NewsError("Failed to fetch news by source"));
      }
    });

    on<FetchTrendingNews>((event, emit) async {
      emit(NewsLoading());
      try {
        currentPage = 1;
        final articles = await newsRepository.fetchTrendingNews();
        emit(NewsLoaded(articles));
      } catch (e) {
        emit(NewsError("Failed to fetch trending news"));
      }
    });

    on<FetchMoreTrendingNews>((event, emit) async {
      try {
        final moreArticles =
            await newsRepository.fetchMoreTrendingNews(++currentPage);
        if (state is NewsLoaded) {
          final currentArticles = (state as NewsLoaded).articles;
          emit(NewsLoaded(currentArticles + moreArticles));
        } else {
          emit(NewsLoaded(moreArticles));
        }
      } catch (e) {
        emit(NewsError("Failed to fetch more trending news"));
      }
    });

    on<FetchMoreNewsBySource>((event, emit) async {
      try {
        currentPage++;
        final articles = await newsRepository.fetchNewsBySource(event.sourceId);
        allArticles = articles!;
        emit(NewsLoaded(allArticles));
      } catch (e) {
        emit(NewsError("Failed to load more news"));
      }
    });

    on<SearchNewsEvent>((event, emit) async {
      emit(NewsLoading());
      try {
        final searchResults = await newsRepository.searchNews(event.query);
        emit(NewsLoaded(searchResults));
      } catch (e) {
        emit(NewsError("Failed to load search results"));
      }
    });
  }
}
