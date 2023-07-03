part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController controller;

  const OnMapInitializedEvent(this.controller);
}

class StartFollowingUserEvent extends MapEvent {}

class StopFollowingUserEvent extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> points;

  const UpdateUserPolylineEvent(this.points);
}

class OnToggledUserRoute extends MapEvent {}
