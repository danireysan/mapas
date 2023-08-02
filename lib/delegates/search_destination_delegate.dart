import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas/models/models.dart';

import '../blocs/blocs.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResultModel> {
  SearchDestinationDelegate() : super(searchFieldLabel: 'Buscar...');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    final searchResult = SearchResultModel(cancel: true);
    return IconButton(
      onPressed: () => close(context, searchResult),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnownLocation!;

    searchBloc.getPlacesQuery(proximity, query);
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;
        return ListView.separated(
          itemCount: state.places.length,
          itemBuilder: (context, index) {
            final place = places[index];
            return ListTile(
              title: Text(place.text),
              subtitle: Text(place.placeName),
              leading: const Icon(
                Icons.place_outlined,
                color: Colors.black,
              ),
              onTap: () {
                final result = SearchResultModel(
                  cancel: false,
                  manual: false,
                  position: LatLng(place.center[1], place.center[0]),
                  destinyName: place.text,
                  description: place.placeName,
                );

                searchBloc.add(AddToHistoryEvent(place));
                close(context, result);
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final history = BlocProvider.of<SearchBloc>(context).state.history;
    return ListView(
      children: [
        ListTile(
          leading: const Icon(
            Icons.location_on_outlined,
            color: Colors.black,
          ),
          title: const Text('Colocar ubicación manualmente',
              style: TextStyle(color: Colors.black)),
          onTap: () {
            final searchBloc = context.read<SearchBloc>();
            searchBloc.add(ActivateManualMarkerEvent());
            final searchResult = SearchResultModel(
              cancel: false,
              manual: true,
            );
            close(context, searchResult);
          },
        ),
        ...history.map((place) => ListTile(
              title: Text(place.text),
              subtitle: Text(place.placeName),
              leading: const Icon(
                Icons.history,
                color: Colors.black,
              ),
              onTap: () {
                final searchBloc = context.read<SearchBloc>();
                final searchResult = SearchResultModel(
                  cancel: false,
                  manual: false,
                  position: LatLng(place.center[1], place.center[0]),
                  destinyName: place.text,
                  description: place.placeName,
                );
                searchBloc.add(AddToHistoryEvent(place));
                close(context, searchResult);
              },
            ))
      ],
    );
  }
}
