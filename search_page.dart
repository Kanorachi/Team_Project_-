import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Detail.dart';
import 'favorite_car.dart';
import 'All_Cars_Page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  Future<void> fetchSearchResults(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://localhost:3000/cars'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> filteredCars = jsonData.where((car) {
          String name = car['name']?.toLowerCase() ?? '';
          String model = car['car_model']?.toLowerCase() ?? '';
          return name.contains(query.toLowerCase()) ||
              model.contains(query.toLowerCase());
        }).toList();

        setState(() {
          searchResults = filteredCars;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch car data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch car data. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Listen for changes in the TextField
    _searchController.addListener(() {
      String query = _searchController.text;
      if (query.isNotEmpty) {
        fetchSearchResults(query);
      } else {
        setState(() {
          searchResults = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void navigateToDetailPage(BuildContext context, dynamic car) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarDetailPage(
          carName: car['name'] ?? 'Unknown',
          carPrice:
              double.tryParse(car['Car_rental price']?.toString() ?? '0.0') ??
                  0.0,
          imageCar: car['image_car'] ?? '',
          carDetail: car['car_detail'] ?? 'No details available',
          carModel: car['car_model'] ?? 'Unknown model',
          onFavoriteToggle: (FavoriteCar favoriteCar) {
            print('${favoriteCar.model} was toggled as favorite');
          },
          favoriteCars: [], // Add favoriteCars here if available
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Cars'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search car',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String searchQuery = _searchController.text;
                if (searchQuery.isNotEmpty) {
                  fetchSearchResults(searchQuery).then((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllCarsPage(
                          searchQuery: searchQuery,
                          searchResults: searchResults, // Send search results
                        ),
                      ),
                    );
                  });
                }
              },
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : searchResults.isEmpty
                      ? Center(child: Text('No cars found'))
                      : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            var car = searchResults[index];
                            return Card(
                              elevation: 4, // Shadow effect
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0), // Space between cards
                              child: ListTile(
                                contentPadding: EdgeInsets.all(
                                    16.0), // Padding inside ListTile
                                leading: Image.network(
                                  car['image_car'] ??
                                      '', // Display the car's image
                                  width: 100, // Set the width of the image
                                  height: 100, // Set the height of the image
                                  fit: BoxFit
                                      .cover, // Ensure the image fits within the box
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons
                                        .error); // Display an error icon if image loading fails
                                  },
                                ),
                                title: Text(car['name'] ?? 'Unknown',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    car['car_model'] ?? 'Unknown model',
                                    style: TextStyle(color: Colors.grey[600])),
                                onTap: () => navigateToDetailPage(context, car),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
