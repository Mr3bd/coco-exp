import 'package:bloc/bloc.dart';
import 'package:coco_task/API/api_repository.dart';
import 'package:coco_task/Models/categories_model.dart';
import 'package:equatable/equatable.dart';
part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesInitial()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<GetCategoriesList>((event, emit) async {
      try {
        emit(CategoriesLoading());
        final mList = await _apiRepository.fetchCategoriesList();
        emit(CategoriesLoaded(mList));
        if (mList.error != null) {
          emit(CategoriesError(mList.error));
        }
      } on NetworkError {
        emit(const CategoriesError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
