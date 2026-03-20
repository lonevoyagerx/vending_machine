class Order {
  final String id;
  final String? userId;
  final String? machineId;
  final String? productId;
  final int? slotNumber;
  final String status;
  final double amount;
  final DateTime? createdAt;

  Order({
    required this.id,
    this.userId,
    this.machineId,
    this.productId,
    this.slotNumber,
    this.status = 'PENDING',
    required this.amount,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      machineId: json['machine_id'] as String?,
      productId: json['product_id']?.toString(), // Handle bigints as strings
      slotNumber: json['slot_number'] as int?,
      status: json['status'] as String? ?? 'PENDING',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (userId != null) 'user_id': userId,
    if (machineId != null) 'machine_id': machineId,
    if (productId != null) 'product_id': productId,
    if (slotNumber != null) 'slot_number': slotNumber,
    'status': status,
    'amount': amount,
  };
}
