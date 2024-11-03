import 'package:equatable/equatable.dart';

abstract class SavedArticlesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSavedArticles extends SavedArticlesEvent {}

class DeleteSelectedArticles extends SavedArticlesEvent {
  final List<bool> selectedArticles;

  DeleteSelectedArticles(this.selectedArticles);

  @override
  List<Object?> get props => [selectedArticles];
}
