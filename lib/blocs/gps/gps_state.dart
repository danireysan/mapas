part of 'gps_bloc.dart';

class GpsState extends Equatable {
  final bool isGpsEnabled;
  final bool isPermissionGranted;

  bool get isAllGranted => isGpsEnabled && isPermissionGranted;

  const GpsState({
    required this.isGpsEnabled,
    required this.isPermissionGranted,
  });

  factory GpsState.initialState() => const GpsState(
        isGpsEnabled: false,
        isPermissionGranted: false,
      );

  // create copywith
  GpsState copyWith({
    bool? isGpsEnabled,
    bool? isPermissionGranted,
  }) =>
      GpsState(
        isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
        isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      );
  @override
  String toString() =>
      'GpsState(isGpsEnabled: $isGpsEnabled, isPermissionGranted: $isPermissionGranted)';

  @override
  List<Object> get props => [isGpsEnabled, isPermissionGranted];
}
