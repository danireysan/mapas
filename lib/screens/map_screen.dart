import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas/views/views.dart';
import 'package:mapas/widgets/widgets.dart';

import '../blocs/blocs.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final LocationBloc locationBloc;
  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.lastKnownLocation == null) {
            return const Center(
              child: Text('Ubicando...'),
            );
          }

          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {
              Map<String, Polyline> polylines = Map.from(mapState.polylines);

              if (!mapState.showMyRoute) {
                polylines.removeWhere((key, value) => 'my_route' == key);
              }
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    MapView(
                      initialLocaltion: locationState.lastKnownLocation!,
                      polylines: mapState.polylines.values.toSet(),
                    ),
                    const SearchBar()
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          BtnFollowUser(),
          BtnCurrentLocation(),
          BtnShowPolyline(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.stopFollowingUser();
    super.dispose();
  }
}
