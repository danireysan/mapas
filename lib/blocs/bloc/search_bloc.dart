import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapas/models/models.dart';
import 'package:mapas/models/places_models.dart';

import '../../services/services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TrafficService trafficService;
  SearchBloc({
    required this.trafficService,
  }) : super(const SearchState()) {
    on<ActivateManualMarkerEvent>((event, emit) {
      emit(state.copyWith(displayManualMarker: true));
    });

    on<DeactivateManualMarkerEvent>((event, emit) {
      emit(state.copyWith(displayManualMarker: false));
    });

    on<OnNewFoundPlacesEvent>((event, emit) {
      final places = event.places;
      emit(state.copyWith(places: places));
    });

    on<AddToHistoryEvent>((event, emit) => emit(
          state.copyWith(history: [event.place, ...state.history]),
        ));
  }

  Future<RouteDestination> getCordsStartToEnd(LatLng start, LatLng end) async {
    final trafficResonse = await trafficService.getCordsStartToEnd(start, end);
    // Destination info
    final endplace = await trafficService.getInformationByCoors(end);

    final geometry = trafficResonse.routes[0].geometry;
    final duration = trafficResonse.routes[0].duration;
    final distance = trafficResonse.routes[0].distance;

    final points = decodePolyline(geometry, accuracyExponent: 6);

    final latLngList = points
        .map((point) => LatLng(point[0].toDouble(), point[1].toDouble()))
        .toList();

    final routeDestination = RouteDestination(
      points: latLngList,
      duration: duration,
      distance: distance,
      endplace: endplace,
    );

    return routeDestination;
  }

  Future getPlacesQuery(LatLng proximity, String query) async {
    final newPlaces = await trafficService.getResultsByQuery(proximity, query);
    add(OnNewFoundPlacesEvent(newPlaces));
  }
}
