import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Brand.dart'; // Import the BrandPage

class AllBrandsPage extends StatefulWidget {
  @override
  _AllBrandsPageState createState() => _AllBrandsPageState();
}

class _AllBrandsPageState extends State<AllBrandsPage> {
  List<dynamic> carBrands = [];

  @override
  void initState() {
    super.initState();
    loadCarData();
  }

  Future<void> loadCarData() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/cars'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      Map<String, dynamic> uniqueBrands = {};
      for (var brand in jsonData) {
        if (!uniqueBrands.containsKey(brand['name'])) {
          uniqueBrands[brand['name']] = brand;
        }
      }
      setState(() {
        carBrands = uniqueBrands.values.toList();
      });
    } else {
      print('Failed to load car data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Brands'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: carBrands.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1,
                ),
                itemCount: carBrands.length,
                itemBuilder: (context, index) {
                  var brand = carBrands[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BrandPage(
                              brandName: brand['name'],
                              logoLink: brand['logo_link']),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              brand['logo_link']),
                          backgroundColor: Colors.grey[300],
                        ),
                        SizedBox(height: 8),
                        Text(brand['name']),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
