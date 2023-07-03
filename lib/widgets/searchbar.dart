import 'package:flutter/material.dart';

import '../delegates/search_destination_delegate.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

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