// To parse this JSON data, do
//
//     final placesResponse = placesResponseFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

class PlacesResponse {
  final String type;
  final List<Feature> features;
  final String attribution;

  PlacesResponse({
    required this.type,
    required this.features,
    required this.attribution,
  });

  factory PlacesResponse.fromRawJson(String str) =>
      PlacesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlacesResponse.fromJson(Map<String, dynamic> json) => PlacesResponse(
        type: json["type"],
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
      };

  // create to String method
  @override
  String toString() {
    return 'PlacesResponse(type: $type, features: $features, attribution: $attribution)';
  }
}

class Feature {
  final String id;
  final String type;
  final List<String> placeType;
  final Properties properties;
  final String text;
  final String placeName;
  final String? matchingText;
  final String? matchingPlaceName;
  final List<double> center;
  final Geometry geometry;
  final List<Context> context;

  Feature({
    required this.id,
    required this.type,
    required this.placeType,
    required this.properties,
    required this.text,
    required this.placeName,
    required this.matchingText,
    required this.matchingPlaceName,
    required this.center,
    required this.geometry,
    required this.context,
  });

  factory Feature.fromRawJson(String str) => Feature.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        properties: Properties.fromJson(json["properties"]),
        text: json["text"],
        placeName: json["place_name"],
        matchingText: json["matching_text"],
        matchingPlaceName: json["matching_place_name"],
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        context:
            List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "properties": properties.toJson(),
        "text": text,
        "place_name": placeName,
        "matching_text": matchingText,
        "matching_place_name": matchingPlaceName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "context": List<dynamic>.from(context.map((x) => x.toJson())),
      };

  // create to String method
  @override
  String toString() {
    return 'Feature(id: $id, type: $type, placeType: $placeType, properties: $properties, text: $text, placeName: $placeName, matchingText: $matchingText, matchingPlaceName: $matchingPlaceName, center: $center, geometry: $geometry, context: $context)';
  }
}

class Context {
  final String id;
  final String mapboxId;
  final String text;
  final String? wikidata;
  final ShortCode? shortCode;

  Context({
    required this.id,
    required this.mapboxId,
    required this.text,
    required this.wikidata,
    required this.shortCode,
  });

  factory Context.fromRawJson(String str) => Context.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        mapboxId: json["mapbox_id"],
        text: json["text"],
        wikidata: json["wikidata"],
        shortCode: shortCodeValues.map[json["short_code"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mapbox_id": mapboxId,
        "text": text,
        "wikidata": wikidata,
        "short_code": shortCodeValues.reverse[shortCode],
      };
}

enum ShortCode { MX, MX_CMX, MX_MEX }

final shortCodeValues = EnumValues({
  "mx": ShortCode.MX,
  "MX-CMX": ShortCode.MX_CMX,
  "MX-MEX": ShortCode.MX_MEX
});

class Geometry {
  final List<double> coordinates;
  final String type;

  Geometry({
    required this.coordinates,
    required this.type,
  });

  factory Geometry.fromRawJson(String str) =>
      Geometry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
      };
}

class Properties {
  final String? wikidata;
  final String? category;
  final bool? landmark;
  final String? address;
  final String? foursquare;
  final String? accuracy;
  final String? mapboxId;

  Properties({
    required this.wikidata,
    required this.category,
    required this.landmark,
    required this.address,
    required this.foursquare,
    required this.accuracy,
    required this.mapboxId,
  });

  factory Properties.fromRawJson(String str) =>
      Properties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        wikidata: json["wikidata"],
        category: json["category"],
        landmark: json["landmark"],
        address: json["address"],
        foursquare: json["foursquare"],
        accuracy: json["accuracy"],
        mapboxId: json["mapbox_id"],
      );

  Map<String, dynamic> toJson() => {
        "wikidata": wikidata,
        "category": category,
        "landmark": landmark,
        "address": address,
        "foursquare": foursquare,
        "accuracy": accuracy,
        "mapbox_id": mapboxId,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
