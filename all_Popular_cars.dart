import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Detail.dart'; // Import the CarDetailPage
import 'favorite_car.dart'; // Import the FavoriteCar model

class PopularCarsPage extends StatefulWidget {
  @override
  _PopularCarsPageState createState() => _PopularCarsPageState();
}

class _PopularCarsPageState extends State<PopularCarsPage> {
  List<dynamic> cars = []; // รายการรถจาก API
  List<FavoriteCar> favoriteCars = [];

  @override
  void initState() {
    super.initState();
    fetchCars(); // ดึงข้อมูลเมื่อหน้าโหลด
  }

  // ฟังก์ชันในการดึงข้อมูลจาก API
  Future<void> fetchCars() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/cars'));
      if (response.statusCode == 200) {
        setState(() {
          cars = jsonDecode(response.body);
        });
      } else {
        print('Failed to load cars');
      }
    } catch (e) {
      print('Error fetching cars: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Cars'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: cars.isEmpty
          ? Center(
              child: CircularProgressIndicator()) // แสดงตัวโหลดขณะดึงข้อมูล
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
                            carName: car["car_model"] ?? "Unknown model",
                            carPrice:
                                car["Car_rental price"]?.toDouble() ?? 0.0,
                            imageCar: car["image_car"] ??
                                'https://example.com/placeholder.jpg',
                            carDetail: car["car_detail"] ??
                                "No details available", // รายละเอียด
                            carModel: car['car_model'] ?? 'Unknown Model',
                            favoriteCars: favoriteCars,
                            onFavoriteToggle: (FavoriteCar toggledCar) {
                              setState(() {
                                if (favoriteCars.contains(toggledCar)) {
                                  favoriteCars.remove(toggledCar);
                                } else {
                                  favoriteCars.add(toggledCar);
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
                        height: 250, // ปรับขนาดให้สูงขึ้นเพื่อให้แสดงรูปเต็ม
                        child: Stack(
                          children: [
                            // ปรับขนาดรูปให้เต็มกรอบทั้งหน้าจอ
                            Positioned.fill(
                              child: Image.network(
                                car["image_car"] ??
                                    'https://example.com/placeholder.jpg',
                                fit: BoxFit.cover, // ปรับให้รูปเต็มกรอบ
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error);
                                },
                              ),
                            ),
                            // จัดข้อความให้อยู่ตรงกลางแนวนอนและอยู่ด้านล่าง
                            Positioned(
                              bottom: 10, // ขยับให้ข้อความอยู่ที่ด้านล่าง
                              left: 0,
                              right: 0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    car["car_model"] ?? "Unknown model",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      backgroundColor: Colors.black
                                          .withOpacity(0.5), // พื้นหลังโปร่งใส
                                    ),
                                  ),
                                  Text(
                                    '\$${car["Car_rental price"]?.toStringAsFixed(2) ?? '0.00'} / Day',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.5),
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
                );
              },
            ),
    );
  }
}
