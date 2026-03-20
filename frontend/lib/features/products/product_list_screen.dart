import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _client = Supabase.instance.client;
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    // MOCK DATA - bypassing Supabase
    await Future.delayed(
      const Duration(milliseconds: 300),
    ); // Simulate network delay
    return [
      Product(
        id: 1,
        name: 'Cola',
        description: 'Chilled sparkling soda',
        price: 1.50,
        stockQuantity: 10,
        imageUrl:
            'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400',
      ),
      Product(
        id: 2,
        name: 'Chips',
        description: 'Salted potato chips',
        price: 2.00,
        stockQuantity: 15,
        imageUrl:
            'https://images.unsplash.com/photo-1566478919030-26d9eecbed10?w=400',
      ),
      Product(
        id: 3,
        name: 'Chocolate Bar',
        description: 'Dark chocolate bar',
        price: 2.50,
        stockQuantity: 20,
        imageUrl:
            'https://images.unsplash.com/photo-1511381978801-6fbb6316cd04?w=400',
      ),
      Product(
        id: 4,
        name: 'Water Bottle',
        description: 'Pure mineral water',
        price: 1.00,
        stockQuantity: 25,
        imageUrl:
            'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400',
      ),
      Product(
        id: 5,
        name: 'Energy Drink',
        description: 'Boost your energy',
        price: 3.00,
        stockQuantity: 12,
        imageUrl:
            'https://images.unsplash.com/photo-1608113967201-7bc29f5c3b93?w=400',
      ),
      Product(
        id: 6,
        name: 'Cookies',
        description: 'Chocolate chip cookies',
        price: 2.25,
        stockQuantity: 18,
        imageUrl:
            'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400',
      ),
      Product(
        id: 7,
        name: 'Candy Bar',
        description: 'Sweet milk chocolate',
        price: 1.75,
        stockQuantity: 30,
        imageUrl:
            'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=400',
      ),
      Product(
        id: 8,
        name: 'Pretzels',
        description: 'Crunchy salted pretzels',
        price: 1.95,
        stockQuantity: 14,
        imageUrl:
            'https://images.unsplash.com/photo-1597533403108-03a4cce57a6f?w=400',
      ),
      Product(
        id: 9,
        name: 'Granola Bar',
        description: 'Healthy oat bar',
        price: 2.00,
        stockQuantity: 22,
        imageUrl:
            'https://images.unsplash.com/photo-1606312619070-d48b4a14e30a?w=400',
      ),
      Product(
        id: 10,
        name: 'Orange Juice',
        description: 'Fresh squeezed',
        price: 2.75,
        stockQuantity: 16,
        imageUrl:
            'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
      ),
      Product(
        id: 11,
        name: 'Gummy Bears',
        description: 'Fruity gummy candy',
        price: 1.50,
        stockQuantity: 28,
        imageUrl:
            'https://images.unsplash.com/photo-1582759457873-1c6f0ca38647?w=400',
      ),
      Product(
        id: 12,
        name: 'Protein Bar',
        description: 'High protein snack',
        price: 3.25,
        stockQuantity: 10,
        imageUrl:
            'https://images.unsplash.com/photo-1576677002923-8effedefe574?w=400',
      ),
      Product(
        id: 13,
        name: 'Iced Coffee',
        description: 'Cold brew coffee',
        price: 2.95,
        stockQuantity: 14,
        imageUrl:
            'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400',
      ),
      Product(
        id: 14,
        name: 'Popcorn',
        description: 'Butter flavored popcorn',
        price: 1.80,
        stockQuantity: 20,
        imageUrl:
            'https://images.unsplash.com/photo-1505686994434-e3cc5abf1330?w=400',
      ),
      Product(
        id: 15,
        name: 'Trail Mix',
        description: 'Nuts and dried fruit',
        price: 2.50,
        stockQuantity: 16,
        imageUrl:
            'https://images.unsplash.com/photo-1605205186761-a64c92aee191?w=400',
      ),
      Product(
        id: 16,
        name: 'Mints',
        description: 'Refreshing peppermint',
        price: 1.25,
        stockQuantity: 35,
        imageUrl:
            'https://images.unsplash.com/photo-1572482789888-4e41f0e34320?w=400',
      ),
      Product(
        id: 17,
        name: 'Crackers',
        description: 'Whole wheat crackers',
        price: 1.85,
        stockQuantity: 18,
        imageUrl:
            'https://images.unsplash.com/photo-1584558265197-f0b91027c7f2?w=400',
      ),
      Product(
        id: 18,
        name: 'Lemonade',
        description: 'Fresh lemonade',
        price: 2.50,
        stockQuantity: 12,
        imageUrl:
            'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f9a?w=400',
      ),
      Product(
        id: 19,
        name: 'Beef Jerky',
        description: 'Premium beef jerky',
        price: 4.50,
        stockQuantity: 8,
        imageUrl:
            'https://images.unsplash.com/photo-1603569833874-b9b7c3c9487b?w=400',
      ),
      Product(
        id: 20,
        name: 'Nuts Pack',
        description: 'Mixed roasted nuts',
        price: 2.95,
        stockQuantity: 15,
        imageUrl:
            'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=400',
      ),
      Product(
        id: 21,
        name: 'Tea',
        description: 'Iced green tea',
        price: 2.25,
        stockQuantity: 14,
        imageUrl:
            'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
      ),
      Product(
        id: 22,
        name: 'Brownie',
        description: 'Chocolate fudge brownie',
        price: 2.75,
        stockQuantity: 12,
        imageUrl:
            'https://images.unsplash.com/photo-1590080876147-07a89bf8fc78?w=400',
      ),
      Product(
        id: 23,
        name: 'Muffin',
        description: 'Blueberry muffin',
        price: 2.50,
        stockQuantity: 10,
        imageUrl:
            'https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=400',
      ),
      Product(
        id: 24,
        name: 'Yogurt',
        description: 'Greek yogurt cup',
        price: 2.00,
        stockQuantity: 18,
        imageUrl:
            'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Snack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'My Orders',
            onPressed: () => context.push('/orders'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _client.auth.signOut();
              if (mounted) context.go('/');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No snacks available'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => context.push('/payment', extra: product),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: product.imageUrl.isNotEmpty
                            ? Image.network(product.imageUrl, fit: BoxFit.cover)
                            : const Icon(Icons.fastfood, size: 50),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('\$${product.price}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
