class Car {
  final String name;
  final String carModel;
  final double carRentalPrice;
  final String carDetail;
  final String imageCar;
  final String logoLink;

  Car({
    required this.name,
    required this.carModel,
    required this.carRentalPrice,
    required this.carDetail,
    required this.imageCar,
    required this.logoLink,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      name: json['name'],
      carModel: json['car_model'],
      carRentalPrice: json['Car_rental price'].toDouble(),
      carDetail: json['car_detail'],
      imageCar: json['image_car'],
      logoLink: json['logo_link'],
    );
  }
}
