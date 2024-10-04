import 'package:flutter/material.dart';
import 'package:flutter_mini/booking_confirmation_page.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'favorite_car.dart';

class CarDetailPage extends StatelessWidget {
  final String carName;
  final double carPrice;
  final String imageCar;
  final String carDetail;
  final String carModel;
  final Function(FavoriteCar) onFavoriteToggle;
  final List<FavoriteCar> favoriteCars;

  CarDetailPage({
    required this.carName,
    required this.carPrice,
    required this.imageCar,
    required this.carDetail,
    required this.carModel,
    required this.onFavoriteToggle,
    required this.favoriteCars,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carName),
        actions: [
          IconButton(
            icon: Icon(
              favoriteCars.any((favorite) => favorite.model == carName)
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            onPressed: () {
              FavoriteCar favoriteCar = FavoriteCar(
                model: carName,
                price: carPrice,
                image: imageCar,
              );
              onFavoriteToggle(favoriteCar);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$carName favorite toggled!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              child: imageCar.isNotEmpty
                  ? Image.network(imageCar, fit: BoxFit.cover)
                  : Center(child: Icon(Icons.directions_car, size: 100)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Model: $carModel',  // Added car model display
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Text(
                    carDetail,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price: \$${carPrice.toStringAsFixed(2)} / Day',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showBookingPopup(context);
                        },
                        child: Text('Book Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime? pickupDate;
        DateTime? returnDate;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Pickup and Return Date'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            pickupDate = selectedDate;
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pickupDate != null
                                ? 'Pick-up: ${DateFormat('yyyy-MM-dd').format(pickupDate!)}'
                                : 'Pick-up date',
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            returnDate = selectedDate;
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            returnDate != null
                                ? 'Return: ${DateFormat('yyyy-MM-dd').format(returnDate!)}'
                                : 'Return date',
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (pickupDate != null && returnDate != null) {
                      // Create a map with the required data
                      Map<String, dynamic> bookingData = {
                        "carName": carName,
                        "carPrice": carPrice,
                        "imageCar": imageCar,
                        "carDetail": carDetail,
                        "pickupDate": DateFormat('yyyy-MM-dd').format(pickupDate!),
                        "returnDate": DateFormat('yyyy-MM-dd').format(returnDate!)
                      };

                      // Send the POST request
                      var url = Uri.parse('http://localhost:3000/CarRental');
                      var response = await http.post(
                        url,
                        headers: {
                          "Content-Type": "application/json"
                        },
                        body: json.encode(bookingData),
                      );

                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Booking submitted successfully!')),
                        );
                      }
                      // Close the popup before navigating to the next page
                      Navigator.of(context).pop();

                      // Navigate to the BookingConfirmationPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingConfirmationPage(
                            pickupDate: pickupDate!,
                            returnDate: returnDate!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select both pickup and return dates.')),
                      );
                    }
                  },
                  child: Text('Continue'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
