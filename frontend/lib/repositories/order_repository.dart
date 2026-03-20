import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order.dart';

class OrderRepository {
  final _client = Supabase.instance.client;

  /// Insert a new order into Supabase. Returns the created [Order].
  Future<Order> createOrder({
    required String productId,
    String? machineId,
    int? slotNumber,
  }) async {
    final userId = _client.auth.currentUser?.id;

    final payload = <String, dynamic>{
      'product_id': productId,
      'status': 'PENDING',
      'amount': 1.50, // Default for demo, or fetch from product
      if (userId != null) 'user_id': userId,
      if (machineId != null) 'machine_id': machineId,
      if (slotNumber != null) 'slot_number': slotNumber,
    };

    final response = await _client
        .from('orders')
        .insert(payload)
        .select()
        .single();

    return Order.fromJson(response);
  }

  /// Update the status of an existing order (e.g. 'completed', 'failed').
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _client.from('orders').update({'status': status}).eq('id', orderId);
  }

  /// Fetch all orders for the current user.
  Future<List<Order>> getMyOrders() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => Order.fromJson(e)).toList();
  }
}
