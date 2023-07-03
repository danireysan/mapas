import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas/blocs/location/location_bloc.dart';
import 'package:mapas/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  GoogleMapController? _mapController;
  final LocationBloc locationBloc;
  StreamSubscription<LocationState>? locationSubscription;
  MapBloc({required this.locationBloc}) : super(MapState.initialState()) {
    on<OnMapInitializedEvent>(_onInitMap);
    on<StartFollowingUserEvent>(_onStartFollowingUser);

    on<StopFollowingUserEvent>(
      (event, emit) {
        emit(state.copyWith(isFollowingUser: false));
      },
    );

    on<UpdateUserPolylineEvent>(_onNewPolyline);
    on<OnToggledUserRoute>(
      (event, emit) {
        emit(state.copyWith(showMyRoute: !state.showMyRoute));
      },
    );

    locationSubscription = locationBloc.stream.listen((locationState) {
      final isNotInitialized = !(state.isMapInitialized);
      if (isNotInitialized) return;
      final isNotFollowing = !(state.isFollowingUser);
      if (isNotFollowing) return;

      if (locationState.lastKnownLocation != null) {
        moveCamera(locationState.lastKnownLocation!);
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }
    });
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;

    _mapController!.setMapStyle(jsonEncode(uberMapTheme));

    emit(state.copyWith(isMapInitialized: true));
  }

  void moveCamera(LatLng destination) {
    final cameraUpdate = CameraUpdate.newLatLng(destination);
    _mapController?.animateCamera(cameraUpdate);
  }

  _onStartFollowingUser(event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));
    locationBloc.startFollowingUser();
  }

  _onNewPolyline(UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    if (!state.isMapInitialized) return;

    final polyline = Polyline(
      polylineId: const PolylineId('my_route'),
      color: Colors.black87,
      width: 4,
      points: event.points,
    );

    final currentPolyline = Map<String, Polyline>.from(state.polylines);
    currentPolyline['my_route'] = polyline;
    emit(state.copyWith(polylines: currentPolyline));
  }

  @override
  Future<void> close() {
    locationSubscription?.cancel();
    return super.close();
  }
}
