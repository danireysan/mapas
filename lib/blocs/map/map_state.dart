part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showMyRoute;

  final Map<String, Polyline> polylines;
  const MapState({
    required this.isMapInitialized,
    required this.isFollowingUser,
    required this.showMyRoute,
    Map<String, Polyline>? polylines,
  }) : polylines = polylines ?? const {};

  // create copywith
  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showMyRoute,
    Map<String, Polyline>? polylines,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
        showMyRoute: showMyRoute ?? this.showMyRoute,
        polylines: polylines ?? this.polylines,
      );
  factory MapState.initialState() => const MapState(
        isMapInitialized: false,
        isFollowingUser: false,
        showMyRoute: true,
      );

  // create to string method
  @override
  String toString() {
    return 'MapState {\n'
        '  isMapInitialized: $isMapInitialized,\n'
        '  isFollowingUser: $isFollowingUser,\n'
        '  showMyRoute: $showMyRoute,\n'
        '  polylines: $polylines\n'
        '}';
  }

  @override
  List<Object> get props =>
      [isMapInitialized, isFollowingUser, showMyRoute, polylines];
}
