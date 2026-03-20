import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'core/supabase_config.dart';
import 'features/auth/login_screen.dart';
import 'features/products/product_list_screen.dart';
import 'features/payment/payment_screen.dart';
import 'features/qr_display/qr_screen.dart';
import 'features/orders/orders_screen.dart';
import 'models/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase (Use empty strings if not yet provided to avoid crash on startup during demo,
  // but warn user)
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  } catch (e) {
    debugPrint('Supabase init failed: $e');
  }

  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductListScreen(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final product = state.extra as Product;
        return PaymentScreen(product: product);
      },
    ),
    GoRoute(
      path: '/qr',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return QRScreen(
          product: data['product'] as Product,
          orderId: data['orderId'] as String,
        );
      },
    ),
    GoRoute(path: '/orders', builder: (context, state) => const OrdersScreen()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vending Machine',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
