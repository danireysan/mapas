import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../helpers/show_loading_message.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.displayManualMarker) {
          return const _ManualMarkerBody();
        }
        return const SizedBox();
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          const Positioned(
            top: 70,
            left: 20,
            child: _BackBtn(),
          ),
          Center(
            child: Transform.translate(
              offset: const Offset(0.0, -22),
              child: BounceInDown(
                from: 100,
                child: const Icon(
                  Icons.location_on_outlined,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 70,
            left: 40,
            child: _ConfirmButton(),
          ),
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return FadeInUp(
      from: 100,
      duration: const Duration(milliseconds: 300),
      child: MaterialButton(
        elevation: 0,
        color: Colors.black,
        shape: const StadiumBorder(),
        minWidth: size.width - 120,
        child: const Text(
          'Confirmar destino',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          final start = locationBloc.state.lastKnownLocation;
          final end = mapBloc.centralLocation;
          if (start == null || end == null) return;

          showLoadingMessage(context);
          final destination = await searchBloc.getCordsStartToEnd(start, end);
          mapBloc.drawRoutePolyline(destination);

          searchBloc.add(DeactivateManualMarkerEvent());

          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  const _BackBtn();

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      from: 100,
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 20,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () =>
              context.read<SearchBloc>().add(DeactivateManualMarkerEvent()),
        ),
      ),
    );
  }
}
