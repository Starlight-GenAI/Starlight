
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight/feature/domain/use_cases/list_history/list_history.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_event.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_state.dart';

import '../../../../core/resources/data_state.dart';
import '../../../data/data_sources/list_history/list_history_request.dart';
import '../../../data/data_sources/trip_planner/trip_planner_request.dart';
import '../../../domain/use_cases/trip_planner/trip_planner.dart';

class TripPlannerBloc extends Bloc<TripPlannerEvent, TripPlannerState> {
  final TripPlannerUseCase _getTripPlannerUseCase;

  TripPlannerBloc( this._getTripPlannerUseCase) : super(const TripPlannerLoadingState()) {
    on<GetTripPlanner>(_onGetTripPlanner);
  }

  void _onGetTripPlanner(GetTripPlanner event, Emitter<TripPlannerState> emit) async {
    emit(const TripPlannerLoadingState());
    print('leo start');

    try {
      emit(const TripPlannerLoadingState());
      final dataState = await _getTripPlannerUseCase(params: TripPlannerRequestBody( id: event.Id));
      if (dataState is DataSuccess) {
        print('leo 123');
        print(dataState.data!.content![0].locationWithSummary?[0].locationName);
        emit(TripPlannerLoadedState(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(TripPlannerErrorState(dataState.error!));
      }
    } catch (e) {
      emit(TripPlannerErrorState(DioException(error: e.toString(), requestOptions: RequestOptions())));
    }
  }

}
