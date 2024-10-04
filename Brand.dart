import 'dart:convert';
import 'package:flutter/material.dart';
import 'Detail.dart';
import 'favorite_car.dart';
import 'package:flutter/services.dart';

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

class BrandPage extends StatefulWidget {
  final String brandName;
  final String logoLink;

  BrandPage({required this.brandName, required this.logoLink});

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  List<Car> cars = [];
  final List<FavoriteCar> favoriteCars = [];

  @override
  void initState() {
    super.initState();
    loadCarsData();
  }

  Future<void> loadCarsData() async {
    try {
      final String response = await rootBundle.loadString('assets/db.json');
      final data = json.decode(response) as Map<String, dynamic>;
      List<dynamic> carsJson = data['cars'];

      setState(() {
        cars = carsJson
            .map((carJson) => Car.fromJson(carJson))
            .where((car) => car.name == widget.brandName)
            .toList();
      });
    } catch (e) {
      print('Error loading car data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brandName),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: cars.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailPage(
                            carName: car.name,
                            carModel: car.carModel,
                            carPrice: car.carRentalPrice,
                            carDetail: car.carDetail,
                            imageCar: car.imageCar,
                            favoriteCars: favoriteCars,
                            onFavoriteToggle: (FavoriteCar toggledCar) {
                              FavoriteCar newFavoriteCar = FavoriteCar(
                                model: toggledCar.model,
                                price: toggledCar.price,
                                image: toggledCar.image,
                              );

                              setState(() {
                                if (favoriteCars.contains(newFavoriteCar)) {
                                  favoriteCars.remove(newFavoriteCar);
                                } else {
                                  favoriteCars.add(newFavoriteCar);
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(car.imageCar),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                car.carModel,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '\$${car.carRentalPrice.toStringAsFixed(2)} / Day',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}