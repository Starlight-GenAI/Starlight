
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starlight/feature/domain/entities/trip_planner/trip_planner.dart';

import '../../../domain/entities/list_history/list_history.dart';

abstract class TripPlannerState extends Equatable{
  final TripPlannerEntity? list;
  final DioException? error;

  const TripPlannerState({this.list, this.error});

  @override
  List<Object?> get props => [list, error];
}

class TripPlannerLoadingState extends TripPlannerState {
  const TripPlannerLoadingState();

}

class TripPlannerLoadedState extends TripPlannerState {
  const TripPlannerLoadedState(TripPlannerEntity list) : super(list: list);
}

class TripPlannerErrorState extends TripPlannerState {
  const TripPlannerErrorState(DioException error) : super(error: error);
}
