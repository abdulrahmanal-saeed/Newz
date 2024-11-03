// category_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newz/models/sources_response/source.dart';
import 'package:newz/repositories/news_repository.dart';

// الأحداث المحتملة التي يمكن أن تحدث
abstract class CategoryEvent {}

class FetchSources extends CategoryEvent {
  final String categoryId;

  FetchSources(this.categoryId);
}

abstract class CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Source> sources;

  CategoryLoaded(this.sources);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}

// الكتلة الرئيسية التي تتعامل مع الأحداث
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final NewsRepository newsRepository;

  CategoryBloc(this.newsRepository) : super(CategoryLoading()) {
    on<FetchSources>((event, emit) async {
      emit(CategoryLoading());
      try {
        final sources = await newsRepository.fetchSources(event.categoryId);
        emit(CategoryLoaded(sources));
      } catch (e) {
        emit(CategoryError("Failed to fetch sources"));
      }
    });
  }
}
