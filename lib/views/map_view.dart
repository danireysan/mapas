import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/blocs.dart';

class MapView extends StatelessWidget {
  const MapView({
    super.key,
    required this.initialLocaltion,
    required this.polylines,
    required this.markers,
  });

  final LatLng initialLocaltion;
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition initialCameraPosition = CameraPosition(
      target: initialLocaltion,
      zoom: 15,
    );
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (_) {
          mapBloc.add(StopFollowingUserEvent());
        },
        child: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          polylines: polylines,
          initialCameraPosition: initialCameraPosition,
          markers: markers,
          onMapCreated: (controller) => mapBloc.add(
            OnMapInitializedEvent(controller),
          ),
          onCameraMove: (cameraPosition) =>
              mapBloc.centralLocation = cameraPosition.target,
        ),
      ),
    );
  }
}
