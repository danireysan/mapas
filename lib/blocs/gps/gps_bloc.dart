import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? _gpsStatusSubscription;

  GpsBloc() : super(GpsState.initialState()) {
    on<GpsAndPermissionEvent>((event, emit) {
      emit(
        state.copyWith(
          isGpsEnabled: event.isGpsEnabled,
          isPermissionGranted: event.isPermissionGranted,
        ),
      );
    });

    _init();
  }

  Future<void> _init() async {
    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted(),
    ]);

    add(GpsAndPermissionEvent(
      isGpsEnabled: gpsInitStatus[0],
      isPermissionGranted: gpsInitStatus[1],
    ));
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGpsStatus() async {
    final isEnabled = await geo.Geolocator.isLocationServiceEnabled();

    _gpsStatusSubscription =
        geo.Geolocator.getServiceStatusStream().listen((event) {
      log("Service status: ${event.toString()}", name: 'GpsBloc');
      final isEnabled = event == geo.ServiceStatus.enabled;
      add(GpsAndPermissionEvent(
        isGpsEnabled: isEnabled,
        isPermissionGranted: true,
      ));
    });

    return isEnabled;
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();

    // make a switch for status
    switch (status) {
      case PermissionStatus.granted:
        add(const GpsAndPermissionEvent(
          isGpsEnabled: true,
          isPermissionGranted: true,
        ));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.provisional:
        add(const GpsAndPermissionEvent(
          isGpsEnabled: false,
          isPermissionGranted: false,
        ));
        openAppSettings();
        break;
    }
  }

  @override
  Future<void> close() async {
    _gpsStatusSubscription?.cancel();
    await super.close();
  }
}
