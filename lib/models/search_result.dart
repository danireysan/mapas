class SearchResultModel {
  final bool cancel;
  final bool? manual;

  SearchResultModel({
    required this.cancel,
    this.manual = false,
  });

  // create to string method
  @override
  String toString() {
    return 'cancel: $cancel, manual: $manual';
  }
}
