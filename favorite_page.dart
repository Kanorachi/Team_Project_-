import 'package:flutter/material.dart';
import 'favorite_car.dart';

class FavoritePage extends StatelessWidget {
  final List<FavoriteCar> favoriteCars;
  final Function(FavoriteCar) onRemoveFavorite;

  FavoritePage({required this.favoriteCars, required this.onRemoveFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Cars'),
      ),
      body: favoriteCars.isEmpty
          ? Center(child: Text('No favorite cars added.'))
          : ListView.builder(
              itemCount: favoriteCars.length,
              itemBuilder: (context, index) {
                final car = favoriteCars[index];
                return ListTile(
                  leading: Image.network(
                    car.image,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error),
                  ),
                  title: Text(car.model),
                  subtitle: Text('\$${car.price.toString()} per day'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      // แสดง popup ยืนยันก่อนลบ
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text('Are you sure you want to remove ${car.model} from favorites?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Remove'),
                                onPressed: () {
                                  onRemoveFavorite(car);
                                  Navigator.of(context).pop(); // ปิด Dialog
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${car.model} removed from favorites!'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
