import '../models/food_item.dart';

class FoodRepository {
  Future<List<FoodItem>> getFoods() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      FoodItem(
        id: 1,
        name: 'Burger',
        description: 'Juicy beef burger with cheese',
        price: 8.99,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=60',
      ),
      FoodItem(
        id: 2,
        name: 'Pizza',
        description: 'Margherita pizza with fresh basil',
        price: 12.50,
        imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?auto=format&fit=crop&w=500&q=60',
      ),
      FoodItem(
        id: 3,
        name: 'Sushi',
        description: 'Assorted sushi platter',
        price: 15.99,
        imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=500&q=60',
      ),
      FoodItem(
        id: 4,
        name: 'Pasta',
        description: 'Creamy Alfredo pasta',
        price: 10.99,
        imageUrl: 'https://images.unsplash.com/photo-1626844131082-256783844137?auto=format&fit=crop&w=500&q=60',
      ),
      FoodItem(
        id: 5,
        name: 'Salad',
        description: 'Fresh garden salad',
        price: 7.99,
        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=500&q=60',
      ),
    ];
  }
}
