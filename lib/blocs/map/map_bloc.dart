import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas/blocs/location/location_bloc.dart';
import 'package:mapas/models/models.dart';
import 'package:mapas/themes/themes.dart';

import '../../helpers/helpers.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  GoogleMapController? _mapController;
  final LocationBloc locationBloc;
  LatLng? centralLocation;

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

    on<DisplayPolylinesEvent>(
      (event, emit) {
        emit(
            state.copyWith(polylines: event.polylines, markers: event.markers));
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

  void drawRoutePolyline(RouteDestination destination) async {
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black87,
      width: 4,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    double kms = destination.distance / 1000;
    kms = (kms * 100).floor().toDouble();
    kms /= 100;

    double tripDuration = (destination.duration / 60).floorToDouble();
    final startMarkerPin = await getAssetImageMarker();
    final startMarker = Marker(
        icon: startMarkerPin,
        markerId: const MarkerId('start'),
        position: destination.points.first,
        infoWindow: InfoWindow(
          title: 'Mi ubicación',
          snippet: "Kms: $kms, Duración: $tripDuration minutos",
        ));

    final endMarkerPin = await getNewworkImageMarker();
    final endMarker = Marker(
        icon: endMarkerPin,
        markerId: const MarkerId('end'),
        position: destination.points.last,
        infoWindow: InfoWindow(
          title: destination.endplace.text,
          snippet: destination.endplace.placeName,
        ));

    final currentPolylines = Map<String, Polyline>.from(state.polylines);

    currentPolylines['route'] = myRoute;

    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;

    add(DisplayPolylinesEvent(currentPolylines, currentMarkers));

    await Future.delayed(const Duration(milliseconds: 300));
    _mapController!.showMarkerInfoWindow(const MarkerId('Start'));
  }

  @override
  Future<void> close() {
    locationSubscription?.cancel();
    return super.close();
  }
}
