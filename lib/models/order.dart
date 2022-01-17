class Order {
  String orderId;
  String customerId;
  bool isCompleted;
  bool cancelled;

  Order(this.orderId, this.customerId, this.isCompleted, this.cancelled);

  void updateId(String id) {
    this.orderId = id;
  }

  String getId() {
    return this.orderId;
  }

  Map<String, Object> toJson() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'isCompleted': isCompleted,
      'cancelled': cancelled
    };
  }
}
