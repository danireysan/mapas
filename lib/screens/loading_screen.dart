import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas/screens/gps_access_screen.dart';
import 'package:mapas/screens/map_screen.dart';

import '../blocs/gps/gps_bloc.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        if (state.isAllGranted) {
          return const MapScreen();
        }
        return const GpsAccessScreen();
      },
    );
  }
}
