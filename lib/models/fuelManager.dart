class FuelManager {
  String id;
  String date;
  String distance;
  String fuel;
  int cost;
  String to;
  String from;

  FuelManager(
    this.id,
    this.date,
    this.distance,
    this.fuel,
    this.cost,
    this.to,
    this.from,
  );

  void updateId(String id) {
    this.id = id;
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'date': date,
      'distance': distance,
      'fuel': fuel,
      'cost': to,
      'location': from,
    };
  }
}
