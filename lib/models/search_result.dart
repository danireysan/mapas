import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResultModel {
  final bool cancel;
  final bool? manual;
  final LatLng? position;
  final String? destinyName;
  final String? description;

  SearchResultModel({
    required this.cancel,
    this.manual = false,
    this.position,
    this.destinyName,
    this.description,
  });

  // create to string method
  @override
  String toString() {
    return 'cancel: $cancel, manual: $manual, position: $position, destinyName: $destinyName, description: $description';
  }
}
