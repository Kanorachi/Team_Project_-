import 'package:flutter/material.dart';

class BookingConfirmationPage extends StatelessWidget {
  final DateTime pickupDate;
  final DateTime returnDate;

  BookingConfirmationPage({
    required this.pickupDate,
    required this.returnDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Confirmation')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Your Booking is Confirmed!',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Pick-up Date: ${pickupDate.toLocal()}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              'Return Date: ${returnDate.toLocal()}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // ส่งข้อมูลกลับไปยังหน้า CarRentalPage
                Navigator.pop(context, {
                  'pickupDate': pickupDate,
                  'returnDate': returnDate,
                });
              },
              child: Text('Back to Car Rental'),
            ),
          ],
        ),
      ),
    ),
   );
  }
}
