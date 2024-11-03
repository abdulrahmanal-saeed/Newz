import 'package:equatable/equatable.dart';

abstract class SavedArticlesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SavedArticlesLoading extends SavedArticlesState {}

class SavedArticlesLoaded extends SavedArticlesState {
  final List<Map<String, dynamic>> articles;
  final List<bool> selectedArticles;
  final bool isEditMode;
  final bool isAllSelected;

  SavedArticlesLoaded({
    required this.articles,
    required this.selectedArticles,
    this.isEditMode = false,
    this.isAllSelected = false,
  });

  @override
  List<Object?> get props =>
      [articles, selectedArticles, isEditMode, isAllSelected];
}

class SavedArticlesError extends SavedArticlesState {
  final String message;

  SavedArticlesError(this.message);

  @override
  List<Object?> get props => [message];
}
