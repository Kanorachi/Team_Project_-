class FavoriteCar {
  final String model;
  final double price;
  final String image;

  FavoriteCar({required this.model, required this.price, required this.image});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteCar &&
          runtimeType == other.runtimeType &&
          model == other.model;

  @override
  int get hashCode => model.hashCode;
}
