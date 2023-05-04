class DestinationsModel {
  DestinationsModel({
    this.destination,
  });
  String? destination;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'destination': destination,
      };
  static DestinationsModel fromJson(Map<String, dynamic> json) =>
      DestinationsModel(
        destination:
            json['destination'] == null ? '' : json['destination'] as String,
      );
}
