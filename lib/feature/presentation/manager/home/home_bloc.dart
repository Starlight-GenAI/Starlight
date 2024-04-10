import 'package:starlight/core/resources/data_state.dart';
import 'package:starlight/feature/presentation/manager/home/home_event.dart';
import 'package:starlight/feature/presentation/manager/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/get_youtube_search.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{

  final GetYoutubeSearchUseCase _getYoutubeSearchUseCase;
  HomeBloc(this._getYoutubeSearchUseCase): super(const HomeLoadingState()){
    on <YoutubeSearch> (onGetYoutubeSearch);
  }

  void onGetYoutubeSearch(YoutubeSearch youtubeSearch, Emitter<HomeState> emit) async{
    final dataState = await _getYoutubeSearchUseCase();
    print(dataState);

    if(dataState is DataSuccess && dataState.data != null){
      emit(
        HomeLoadedState(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      print(dataState.error!.message);

      emit(
        HomeErrorState(dataState.error!)
      );
    }
  }

}