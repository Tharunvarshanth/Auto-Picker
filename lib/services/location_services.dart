import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationServices {
  final String key = "AIzaSyD7n81mZhsYBJYucjZL4iAkhWtxWW9tg3s";

  Future<String> getPlaceId(String input) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print("LocationServices:getPlaceId ${json}");
    if (json["candidates"].length == 0) {
      return "";
    }
    var placeId = json["candidates"][0]['place_id'] as String;
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print("LocationServices:getPlace ${json}");
    var results = json["result"] as Map<String, dynamic>;
    return results;
  }
}
