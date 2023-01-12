import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

class PayhereService {
  static const merchant_secret =
      "MTAzNzY5Mzk5MzIwODg3NjgxNzAxMDkzNzg1MzE2ODQ0MjcyMTA1";
  static const merchant_id = "1221939";

  Map paymentObject = {
    "sandbox": true, // true if using Sandbox Merchant ID
    "merchant_id": merchant_id, // Replace your Merchant ID
    "merchant_secret": merchant_id, // See step 4e
    "notify_url": "http://autopicker.com/",
    "order_id": "",
    "items": "",
    "amount": "",
    "currency": "LKR",
    "first_name": "",
    "last_name": "",
    "email": "",
    "phone": "",
    "address": "",
    "city": "o",
    "country": "Sri Lanka",
    "delivery_address": "",
    "delivery_city": "",
    "delivery_country": "Sri Lanka",
  };

  oneTimePayment(String orderId, String item, String amount, String fname,
      String lname, String email, String phone, String address, String city) {
    paymentObject["order_id"] = orderId;
    paymentObject["item"] = item;
    paymentObject["amount"] = amount;
    paymentObject["first_name"] = fname;
    paymentObject["last_name"] = lname;
    paymentObject["email"] = email;
    paymentObject["phone"] = phone;
    paymentObject["address"] = address;
    paymentObject["delivery_address"] = address;
    paymentObject["delivery_city"] = city;
    return paymentObject;
  }

  recurrencePayment(
      String orderId,
      String item,
      String amount,
      String fname,
      String lname,
      String email,
      String phone,
      String address,
      String city,
      String recurrence,
      String recurrenceYear) {
    paymentObject["order_id"] = orderId;
    paymentObject["item"] = item;
    paymentObject["amount"] = amount;
    paymentObject["first_name"] = fname;
    paymentObject["last_name"] = lname;
    paymentObject["email"] = email;
    paymentObject["phone"] = phone;
    paymentObject["address"] = address;
    paymentObject["delivery_address"] = address;
    paymentObject["delivery_city"] = city;
    paymentObject["recurrence"] = recurrence; // "1 Month",
    paymentObject["duration"] = recurrenceYear; //"1 Year",

    PayHere.startPayment(paymentObject, (paymentId) {
      print("Tokenization Payment Success. Payment Id: $paymentId");
      return paymentId;
    }, (error) {
      print("Tokenization Payment Failed. Error: $error");
      return error;
    }, () {
      print("Tokenization Payment Dismissed");
      return "Dismissed";
    });
  }
}
