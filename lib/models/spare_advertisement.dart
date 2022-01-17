class SpareAdvertisement {
  String time;
  String message;
  String endDate;
  String payment;
  String price;
  String description;
  String condition;
  String title;
  String sustitle;

  SpareAdvertisement(this.time, this.message, this.endDate, this.payment,
      this.price, this.description, this.condition, this.title, this.sustitle);

  Map<String, Object> toJson() {
    return {
      'time': time,
      'message': message,
      'endDate': endDate,
      'payment': payment,
      'price': price,
      'description': description,
      'condition': condition,
      'title': title,
      'subtitle': sustitle
    };
  }
}
