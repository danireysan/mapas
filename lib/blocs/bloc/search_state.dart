part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarker;

  const SearchState({
    this.displayManualMarker = false,
  });

  // create a copywith method
  SearchState copyWith({
    bool? displayManualMarker,
  }) =>
      SearchState(
        displayManualMarker: displayManualMarker ?? this.displayManualMarker,
      );

  @override
  List<Object> get props => [displayManualMarker];
}
