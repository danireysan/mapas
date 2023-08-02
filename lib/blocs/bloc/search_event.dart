part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class ActivateManualMarkerEvent extends SearchEvent {}

class DeactivateManualMarkerEvent extends SearchEvent {}

class OnNewFoundPlacesEvent extends SearchEvent {
  final List<Feature> places;

  const OnNewFoundPlacesEvent(this.places);

  @override
  List<Object> get props => [places];
}

// todo: add history event

class AddToHistoryEvent extends SearchEvent {
  final Feature place;

  const AddToHistoryEvent(this.place);

  @override
  List<Object> get props => [place];
}
