import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/product.dart';
import '../../repositories/order_repository.dart';

class PaymentScreen extends StatefulWidget {
  final Product product;
  const PaymentScreen({super.key, required this.product});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  final _orderRepo = OrderRepository();

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      // Create a real order in Supabase
      final order = await _orderRepo.createOrder(
        productId: widget.product.id.toString(),
        // machineId and slotNumber can be passed in from QR / deep-link args later
      );

      if (mounted) {
        context.go(
          '/qr',
          extra: {'product': widget.product, 'orderId': order.id},
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Buying: ${widget.product.name}'),
            Text(
              'Price: \$${widget.product.price}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            _isProcessing
                ? const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Creating order…'),
                    ],
                  )
                : ElevatedButton.icon(
                    onPressed: _processPayment,
                    icon: const Icon(Icons.payment),
                    label: const Text('Pay Now'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
