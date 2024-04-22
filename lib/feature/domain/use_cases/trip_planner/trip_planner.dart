import 'package:starlight/feature/domain/repositories/trip_planner/trip_planner_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/data_sources/trip_planner/trip_planner_request.dart';
import '../../entities/trip_planner/trip_planner.dart';
import '../../entities/video_summary/video_summary.dart';

class TripPlannerUseCase implements UseCase<DataState<TripPlannerEntity>, TripPlannerRequestBody> {
  final TripPlannerRepository _tripPlannerRepository;

  TripPlannerUseCase(this._tripPlannerRepository);

  @override
  Future<DataState<TripPlannerEntity>> call({TripPlannerRequestBody? params}) {
    return _tripPlannerRepository.getPlan(body: params?? TripPlannerRequestBody(id: ""));
  }
}