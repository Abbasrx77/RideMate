import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ridemate/models/trajet.dart';

class ApiService {
  //IMPORTANT!!!!!
  //L'url utilisé ici n'est pas localhost mais l'adresse IP de l'ordinateur sur lequel tourne le serveur laravel
  //L'ordinateur est connecté à un réseau wifi et fait un partage de connexion au smartphone
  //Veuillez remplacer l'adresse IP de l'ordinateur par "localhost:8000" ou l'adresse du serveur concerné

  final String baseUrl = "http://192.168.88.204:8000/api";
  final storage = const FlutterSecureStorage();

  /*Future<String?> getAuthToken(String email, String password) async {
    try{
      final response = await http.post(Uri.parse('baseUrl/connexion'),
        body: jsonEncode({'email': 1, 'password':2}),
      );
      if(response.statusCode == 200){
        await storage.write(key: 'auth_token', value: response.body);
        final token = await storage.read(key: 'auth_token');
        return token;
      }
    }catch(e){
      devtools.log("Erreur : ${e.toString()}");
    }
  }*/

  /*Future<http.Response> get(String endpoint) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: { 'Authorization': 'Bearer $token','Content-Type': 'application/x-www-form-urlencoded', },
    );
    return response;
  }*/

  Future<http.Response> inscription(String endpoint,
      {required Map<String, String> body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    return response;
  }

  Future<http.Response> post_authentification(String endpoint,
      {required Map<String, String?> body}) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    return response;
  }

  Future<http.Response> notify_reservation(
      {required Map<String, dynamic> dataToSend}) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Authorization':
            'key=AAAA0jRbWV4:APA91bEEMv1OriL--T0o8n6WN_cQWJqok0nsPbW84Bh-RNjhQ9q_g2Rd__rneLEwUhHxiPgsC2ds4U45Bak4gQON-HqO25OosBHFSeO5aAvQb_63_OBG1ip78ga4uEhkSr1AXMBIAilV',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(dataToSend),
    );
    print('${response.statusCode} ${response.body}');
    return response;
  }

  Future<List<String>> get_authentification(String endpoint) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: { 'Authorization': 'Bearer $token' , 'Content-Type': 'application/x-www-form-urlencoded', },
    );
    return List<String>.from(json.decode(response.body));
  }

  Future<List<Trajet>> get_trajets(String endpoint) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    if (response.statusCode == 200) {
      // If the server returns a OK response, parse the JSON.
      final body = jsonDecode(response.body);
      return body.map<Trajet>((itemJson) => Trajet.fromJson(itemJson)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load trajet');
    }
  }

  Future<List<Trajet>> rechercher_trajets(String endpoint,
      {required Map<String, String> body}) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      // If the server returns a OK response, parse the JSON.
      final body = jsonDecode(response.body);
      return body.map<Trajet>((itemJson) => Trajet.fromJson(itemJson)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load trajet');
    }
  }

  Future<http.Response> connexion({required Map<String, String> body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/connexion'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    var data = jsonDecode(response.body);
    String token = data[1];
    await storage.write(key: 'auth_token', value: token);
    return response;
  }

  Future<http.Response> patch(String endpoint,
      {required Map<String, String> body}) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> delete(String endpoint,
      {required Map<String, String?> body}) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    return response;
  }

  Future<http.Response> update({required Map<String, dynamic> body}) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    print(response.statusCode);
    return response;
  }

  //API informations des utilisateurs
  /*Future<http.Response> infos({required Map<String, String?> body}) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/infos'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      //body: body,
    );
    return response;
  }*/
  Future<Map<String, dynamic>> infos() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/infos'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    Map<String, dynamic> conducteurInfo = json.decode(response.body);
    return conducteurInfo;
  }

  Future<List<String>> getPlaceSuggestions(String input) async {
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=$input'),
    );

    if (response.statusCode == 200) {
      List<dynamic> places = jsonDecode(response.body);
      return places
          .take(5)
          .map((place) => place['display_name'].toString())
          .toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}
