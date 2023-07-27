import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas/models/models.dart';

import '../blocs/blocs.dart';
import '../delegates/search_destination_delegate.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) =>
          state.displayManualMarker ? const _SearchBarBody() : const SizedBox(),
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({super.key});

  void onSearchResults(BuildContext context, SearchResultModel result) {
    final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);

    if (result.manual == true) {
      searchBloc.add(ActivateManualMarkerEvent());
      return;
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

          if (result == null) return;
        },
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
    );
  }
}
