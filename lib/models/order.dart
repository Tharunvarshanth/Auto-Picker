class Order {
  String orderId;
  String customerId;
  String productId;
  String sellerId;
  bool isCompleted;
  int noOfItems;
  String descriptionCancelled;
  bool cancelled;
  String orderCreatedDate;

  Order(
      this.orderId,
      this.customerId,
      this.productId,
      this.sellerId,
      this.isCompleted,
      this.noOfItems,
      this.descriptionCancelled,
      this.cancelled,
      this.orderCreatedDate);

  void updateId(String id) {
    this.orderId = id;
  }

  String getId() {
    return this.orderId;
  }

  factory Order.fromJson(dynamic json) {
    return Order(
        json['orderId'],
        json['customerId'],
        json["productId"],
        json['sellerId'],
        json['isCompleted'],
        json['noOfItems'],
        json['descriptionCancelled'],
        json['cancelled'],
        json['orderCreatedDate']);
  }

  Map<String, Object> toJson() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'productId': productId,
      'sellerId': sellerId,
      'noOfItems': noOfItems,
      'descriptionCancelled': descriptionCancelled,
      'isCompleted': isCompleted,
      'cancelled': cancelled,
      'orderCreatedDate': orderCreatedDate
    };
  }
}
