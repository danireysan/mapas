import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.08,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 10),
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
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
