class Feedback {
  String message;
  String customerId;

  Feedback(this.message, this.customerId);

  Map<String, Object> toJson() {
    return {'message': message, 'customerId': customerId};
  }
}
