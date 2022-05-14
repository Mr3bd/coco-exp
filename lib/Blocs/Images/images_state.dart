part of 'images_bloc.dart';


abstract class ImagesState extends Equatable {
  const ImagesState();

  @override
  List<Object?> get props => [];
}

class ImagesInitial extends ImagesState {}

class ImagesLoading extends ImagesState {}

class ImagesLoaded extends ImagesState {
  final List<int> images;
  const ImagesLoaded(this.images);
}

class ImagesError extends ImagesState {
  final String? message;
  const ImagesError(this.message);
}
