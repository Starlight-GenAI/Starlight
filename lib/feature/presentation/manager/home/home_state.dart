import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/youtube_search.dart';

abstract class HomeState extends Equatable{
  final YoutubeSearchEntity ? list;
  final DioException ? error;

  const HomeState({this.list, this.error});

  @override
  List<Object> get props => [list!, error!];
}


class HomeLoadingState extends HomeState{
  const HomeLoadingState();

}

class HomeLoadedState extends HomeState{
  const HomeLoadedState(YoutubeSearchEntity list) : super(list: list);

}

class HomeErrorState extends HomeState{
  const HomeErrorState(DioException error) : super(error: error);
}