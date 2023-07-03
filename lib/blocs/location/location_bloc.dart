import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? _positionSubscription;

  LocationBloc() : super(LocationState.initialState()) {
    on<OnStartFollowingUserEvent>((event, emit) {
      log(" I was triggered");
      emit(state.copyWith(followingUser: true));
    });
    on<OnStopFollowingEvent>(
        (event, emit) => emit(state.copyWith(followingUser: false)));

    on<OnNewUserLocationEvent>((event, emit) {
      emit(
        state.copyWith(
          followingUser: true,
          lastKnownLocation: event.newLocation,
          myLocationHistory: [
            ...state.myLocationHistory,
            event.newLocation,
          ],
        ),
      );
    });
  }

  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();

    add(OnNewUserLocationEvent(
      LatLng(position.latitude, position.longitude),
    ));
  }

  void startFollowingUser() {
    add(OnStartFollowingUserEvent());
    _positionSubscription = Geolocator.getPositionStream().listen((position) {
      add(OnNewUserLocationEvent(
        LatLng(position.latitude, position.longitude),
      ));
    });
  }

  void stopFollowingUser() {
    _positionSubscription?.cancel();
    add(OnStopFollowingEvent());
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }
}
