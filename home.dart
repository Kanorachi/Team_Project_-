import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mini/all_brands_page.dart';
import 'package:flutter_mini/all_Popular_cars.dart';
import 'package:flutter_mini/favorite_page.dart';
import 'package:flutter_mini/Brand.dart';
import 'package:flutter_mini/Detail.dart';
import 'package:flutter_mini/favorite_car.dart';
import 'package:flutter_mini/search_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_mini/car_rental_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> carBrands = [];
  List<dynamic> popularCars = [];
  List<FavoriteCar> favoriteCars = [];

  @override
  void initState() {
    super.initState();
    loadCarData();
  }

  Future<void> loadCarData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/cars'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<String> desiredBrands = [
          "Toyota",
          "Ford",
          "BMW",
          "Nissan",
          "Ferrari",
          "Honda",
          "Tesla",
          "Porsche",
          "Lamborghini"
        ];

        setState(() {
          carBrands = jsonData
              .where((brand) =>
                  desiredBrands.contains(brand['name']) &&
                  brand['logo_link'] != null &&
                  brand['logo_link'].isNotEmpty)
              .toList();
          popularCars = jsonData;
        });
      } else {
        print('Failed to load car data');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void toggleFavorite(FavoriteCar favoriteCar) {
    setState(() {
      if (favoriteCars.any((favorite) => favorite.model == favoriteCar.model)) {
        favoriteCars
            .removeWhere((favorite) => favorite.model == favoriteCar.model);
      } else {
        favoriteCars.add(favoriteCar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Car Rental App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, const Color.fromARGB(255, 247, 247, 247)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search car',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                // suffixIcon: Icon(Icons.mic, color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Brands',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllBrandsPage()),
                    );
                  },
                  child: Text('See All', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          Container(
  height: 100,  // Adjusted height for a better layout
  child: carBrands.isEmpty
      ? Center(
          child: CircularProgressIndicator(), // Show loading indicator while data is being loaded
        )
      : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: carBrands.length, // Show filtered brands
          itemBuilder: (context, index) {
            // List of desired brands
            List<String> desiredBrands = [
              "Toyota",
              "Ford",
              "BMW",
              "Nissan",
              "Ferrari",
              "Honda",
              "Tesla",
              "Porsche",
              "Lamborghini"
            ];

            // Use a map to filter out duplicate brand names
            Map<String, dynamic> uniqueBrands = {};
            for (var brand in carBrands) {
              if (desiredBrands.contains(brand['name']) &&
                  !uniqueBrands.containsKey(brand['name'])) {
                uniqueBrands[brand['name']] = brand;
              }
            }

            // Convert map back to a list for rendering
            List<dynamic> filteredBrands = uniqueBrands.values.toList();

            if (index >= filteredBrands.length) return SizedBox(); // In case of overflow

            var brand = filteredBrands[index]; // Use filtered brands

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BrandPage(
                        brandName: brand['name'],
                        logoLink: brand['logo_link'],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        spreadRadius: 0.005,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 35, // Adjusted size for better visibility
                    backgroundImage: NetworkImage(brand['logo_link']),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ),
            );
          },
        ),
),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Cars',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PopularCarsPage()),
                    );
                  },
                  child: Text('See All', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: popularCars.length,
              itemBuilder: (context, index) {
                var car = popularCars[index];
                String imageCar = car['image_car'] ?? '';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailPage(
                            carName: car['name'],
                            carModel: car['car_model'],
                            carPrice: car['Car_rental price']?.toDouble() ?? 0.0,
                            imageCar: imageCar.isNotEmpty
                                ? imageCar
                                : 'https://example.com/placeholder.jpg',
                            carDetail: car['car_detail'] ?? 'No details available',
                            onFavoriteToggle: (FavoriteCar favoriteCar) {
                              toggleFavorite(favoriteCar);
                            },
                            favoriteCars: favoriteCars,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageCar.isNotEmpty
                                  ? imageCar
                                  : 'https://example.com/placeholder.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        car['name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        car['car_model'],
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_max_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental_outlined),
            label: 'Car Rental',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritePage(
                  favoriteCars: favoriteCars,
                  onRemoveFavorite: (FavoriteCar favoriteCar) {
                    setState(() {
                      favoriteCars.removeWhere(
                          (favorite) => favorite.model == favoriteCar.model);
                    });
                  },
                ),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarRentalPage(),
              ),
            );
          }
        },
      ),
    );
  }
}
