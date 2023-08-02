import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas/models/models.dart';

import '../blocs/blocs.dart';
import '../delegates/search_destination_delegate.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) => state.displayManualMarker
          ? const SizedBox()
          : FadeInDown(
              duration: const Duration(milliseconds: 300),
              child: const _SearchBarBody(),
            ),
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody();

  void onSearchResults(BuildContext context, SearchResultModel result) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
    final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
    final locationBloc = BlocProvider.of<LocationBloc>(context, listen: false);
    if (result.manual == true) {
      searchBloc.add(ActivateManualMarkerEvent());
      return;
    }

    if (result.position != null) {
      final destination = await searchBloc.getCordsStartToEnd(
        locationBloc.state.lastKnownLocation!,
        result.position!,
      );
      mapBloc.drawRoutePolyline(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () async {
          final result = await showSearch(
            context: context,
            delegate: SearchDestinationDelegate(),
          );

          log('This is the result: $result');

          if (result == null) return;

          // ignore: use_build_context_synchronously
          onSearchResults(context, result);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  )
                ]),
            child: const Text(
              "Donde quieres ir?",
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}
