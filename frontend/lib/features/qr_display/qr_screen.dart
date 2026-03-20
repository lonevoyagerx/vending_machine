import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/product.dart';

class QRScreen extends StatelessWidget {
  final Product product;
  final String orderId;

  const QRScreen({super.key, required this.product, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collect Order')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Scan this at the machine',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            QrImageView(data: orderId, version: QrVersions.auto, size: 250.0),
            const SizedBox(height: 20),
            Text(product.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            const Text(
              'Valid for 5 minutes',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Order ID (for IoT / testing):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    orderId,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
