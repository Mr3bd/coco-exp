import 'package:bloc/bloc.dart';
import 'package:coco_task/API/api_repository.dart';
import 'package:coco_task/Models/categories_model.dart';
import 'package:equatable/equatable.dart';
part 'images_event.dart';
part 'images_state.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  List<Category>? ids;
  ImagesBloc(this.ids) : super(ImagesInitial()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<GetImagesList>((event, emit) async {
      try {
        emit(ImagesLoading());
        final mList = await _apiRepository.fetchImageByCatsList(ids ?? []);
        emit(ImagesLoaded(mList));
      } on NetworkError {
        emit(const ImagesError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
