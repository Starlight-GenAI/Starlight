
import 'package:starlight/feature/data/data_sources/trip_planner/trip_planner_request.dart';
import 'package:starlight/feature/domain/entities/trip_planner/trip_planner.dart';

import '../../../../core/resources/data_state.dart';

abstract class TripPlannerRepository {
  Future<DataState<TripPlannerEntity>> getPlan({required TripPlannerRequestBody body});

}
