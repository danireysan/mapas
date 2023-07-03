part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;

  final LatLng? lastKnownLocation;
  final List<LatLng> myLocationHistory;
  const LocationState({
    this.followingUser = false,
    this.lastKnownLocation,
    this.myLocationHistory = const [],
  });

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnownLocation,
    List<LatLng>? myLocationHistory,
  }) {
    return LocationState(
      followingUser: followingUser ?? this.followingUser,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      myLocationHistory: myLocationHistory ?? this.myLocationHistory,
    );
  }

  factory LocationState.initialState() => const LocationState();

  @override
  List<Object?> get props => [
        followingUser,
        lastKnownLocation,
        myLocationHistory,
      ];
}
