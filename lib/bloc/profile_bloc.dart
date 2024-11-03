import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String profileImagePath;

  ProfileLoaded(this.name, this.email, this.profileImagePath);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        // افتراض عملية جلب البيانات من البيانات المحفوظة
        const name = 'No name'; // بيانات تجريبية
        const email = 'john.doe@example.com';
        const profileImagePath = 'https://example.com/profile_image.jpg';
        emit(ProfileLoaded(name, email, profileImagePath));
      } catch (e) {
        emit(ProfileError("Failed to load profile"));
      }
    });
  }
}
