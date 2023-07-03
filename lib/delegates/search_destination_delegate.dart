import 'package:flutter/material.dart';
import 'package:mapas/models/models.dart';

class SearchDestinationDelegate extends SearchDelegate<SearhResultModel> {
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
    final searchResult = SearhResultModel(cancel: true);
    return IconButton(
      onPressed: () => close(context, searchResult),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('Build Results');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
            final searchResult = SearhResultModel(
              cancel: false,
              manual: true,
            );
            close(context, searchResult);
          },
        )
      ],
    );
  }
}
