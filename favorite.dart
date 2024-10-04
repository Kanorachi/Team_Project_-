import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // กลับไปหน้าก่อนหน้า
          },
        ),
      ),
      body: ListView.builder(
        itemCount: 3, // จำนวนรายการ 3 รายการ
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: Container(
                height: 150, // ความสูงของการ์ด
                child: Center(
                  child: Text('Item ${index + 1}'),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_max_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental_outlined),
            label: 'Car rental',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
