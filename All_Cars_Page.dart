import 'package:flutter/material.dart';
import 'Detail.dart';
import 'favorite_car.dart';

class AllCarsPage extends StatelessWidget {
  final String searchQuery;
  final List<dynamic> searchResults;

  AllCarsPage({required this.searchQuery, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cars matching "$searchQuery"'),
      ),
      body: Container(
        color: Colors.white, // White background
        padding: const EdgeInsets.all(16.0), // Padding for the body
        child: searchResults.isEmpty
            ? Center(
                child: Text(
                  'No cars found matching "$searchQuery"',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              )
            : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  var car = searchResults[index];
                  return Card(
                    elevation: 4, // Shadow effect
                    margin: EdgeInsets.symmetric(vertical: 8.0), // Space between cards
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0), // Padding inside ListTile
                      leading: car['image_car'] != null && car['image_car'].isNotEmpty
                          ? ClipOval( // Circular image
                              child: Image.network(
                                car['image_car'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, size: 50);
                                },
                              ),
                            )
                          : Icon(Icons.directions_car, size: 50),
                      title: Text(
                        car['name'] ?? 'Unknown Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        car['car_model'] ?? 'Unknown Model',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarDetailPage(
                              carName: car['name'] ?? 'Unknown',
                              carPrice: double.tryParse(car['Car_rental price']?.toString() ?? '0.0') ?? 0.0,
                              imageCar: car['image_car'] ?? '',
                              carDetail: car['car_detail'] ?? 'No details available.',
                              carModel: car['car_model'] ?? 'Unknown Model',
                              onFavoriteToggle: (FavoriteCar favoriteCar) {
                                // Implement favorite toggle logic here
                                print('${favoriteCar.model} was toggled as favorite');
                              },
                              favoriteCars: [], // You can populate this with the actual favorite cars list
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
