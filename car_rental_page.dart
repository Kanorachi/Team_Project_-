import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // สำหรับการแปลงข้อมูล JSON
import 'package:intl/intl.dart'; // สำหรับการจัดรูปแบบวันที่

class CarRentalPage extends StatefulWidget {
  final DateTime? pickupDate;
  final DateTime? returnDate;

  CarRentalPage({this.pickupDate, this.returnDate});

  @override
  _CarRentalPageState createState() => _CarRentalPageState();
}

class _CarRentalPageState extends State<CarRentalPage> {
  List<dynamic> carRentals = []; // เก็บข้อมูลรถเช่า
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCarRentals(); // เรียกฟังก์ชันเมื่อเริ่มต้นหน้า
  }

  Future<void> _fetchCarRentals() async {
    final url = Uri.parse('http://localhost:3000/CarRental');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          carRentals = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  // ฟังก์ชันลบข้อมูล
  Future<void> _deleteCarRental(String id) async {
    final url = Uri.parse('http://localhost:3000/CarRental/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          carRentals.removeWhere((carRental) => carRental['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted successfully')),
        );
      } else {
        print('Failed to delete data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting data: $error');
    }
  }

  // Popup ยืนยันการลบข้อมูล
  void _showDeleteConfirmationDialog(String id, String carName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete the car "$carName"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteCarRental(id);
                Navigator.of(context).pop(); // ปิด dialog หลังจากลบสำเร็จ
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันแก้ไขข้อมูลเฉพาะวันที่
  Future<void> _editCarRental(
      String id, DateTime newPickupDate, DateTime newReturnDate) async {
    final url = Uri.parse('http://localhost:3000/CarRental/$id');

    // หาข้อมูลเดิมของรถเช่าที่จะทำการแก้ไข
    final currentRental =
        carRentals.firstWhere((carRental) => carRental['id'] == id);

    // สร้าง Map ข้อมูลที่จะส่งไปยังเซิร์ฟเวอร์ โดยเก็บข้อมูลเดิมไว้และแก้ไขวันที่
    final Map<String, dynamic> updatedData = {
      'id': currentRental['id'],
      'carName': currentRental['carName'],
      'carPrice': currentRental['carPrice'],
      'carDetail': currentRental['carDetail'],
      'imageCar': currentRental['imageCar'],
      'pickupDate': DateFormat('yyyy-MM-dd').format(newPickupDate),
      'returnDate': DateFormat('yyyy-MM-dd').format(newReturnDate),
    };

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        setState(() {
          final index =
              carRentals.indexWhere((carRental) => carRental['id'] == id);
          if (index != -1) {
            carRentals[index]['pickupDate'] = updatedData['pickupDate'];
            carRentals[index]['returnDate'] = updatedData['returnDate'];
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated successfully')),
        );
      } else {
        print('Failed to update data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating data: $error');
    }
  }

  // Popup สำหรับแก้ไขวันที่
  void _showEditDateDialog(Map<String, dynamic> carRental) {
    DateTime? newPickupDate = carRental['pickupDate'] != null
        ? DateTime.parse(carRental['pickupDate'])
        : null;
    DateTime? newReturnDate = carRental['returnDate'] != null
        ? DateTime.parse(carRental['returnDate'])
        : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Rental Dates'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: newPickupDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      newPickupDate = selectedDate;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      newPickupDate != null
                          ? 'Pick-up: ${DateFormat('yyyy-MM-dd').format(newPickupDate!)}'
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
                    initialDate: newReturnDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      newReturnDate = selectedDate;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      newReturnDate != null
                          ? 'Return: ${DateFormat('yyyy-MM-dd').format(newReturnDate!)}'
                          : 'Return date',
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPickupDate != null && newReturnDate != null) {
                  _editCarRental(
                    carRental['id'],
                    newPickupDate!,
                    newReturnDate!,
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Please select both pickup and return dates.')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Rental'),
        backgroundColor: Colors.blueAccent, // Change the color of the app bar
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Car Rentals',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  if (widget.pickupDate != null &&
                      widget.returnDate != null) ...[
                    Text(
                      'Booking Details:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('Pick-up Date: ${widget.pickupDate!.toLocal()}'),
                    Text('Return Date: ${widget.returnDate!.toLocal()}'),
                    SizedBox(height: 20),
                  ],
                  Expanded(
                    child: ListView.builder(
                      itemCount: carRentals.length,
                      itemBuilder: (context, index) {
                        final carRental = carRentals[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          elevation: 2, // Add elevation for shadow effect
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                          child: ListTile(
                            leading: carRental['imageCar'] != null
                                ? ClipOval( // Circular image
                                    child: Image.network(
                                      carRental['imageCar'],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(Icons.image_not_supported), // แสดงไอคอนแทนถ้า imageCar เป็น null
                            title: Text(
                              carRental['carName'] ?? 'Unknown Car Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // Bold text
                              ),
                            ),
                            subtitle: Text(
                              'Price: \$${carRental['carPrice'] ?? 'N/A'} / Day\nPickup: ${carRental['pickupDate'] ?? 'N/A'}\nReturn: ${carRental['returnDate'] ?? 'N/A'}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDateDialog(
                                        carRental); // เรียก Popup สำหรับแก้ไขวันที่
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                        carRental['id'],
                                        carRental['carName']); // เรียก Popup ยืนยันการลบ
                                  },
                                ),
                              ],
                            ),
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
