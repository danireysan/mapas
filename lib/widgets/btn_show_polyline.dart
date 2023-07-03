import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class BtnShowPolyline extends StatelessWidget {
  const BtnShowPolyline({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(Icons.more_horiz_rounded,
                  color: state.showMyRoute ? Colors.blue : Colors.black54),
              onPressed: () {
                mapBloc.add(OnToggledUserRoute());
              },
            );
          },
        ),
      ),
    );
  }
}
