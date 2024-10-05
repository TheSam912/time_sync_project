import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/public.dart';

class MyRequest {
  static Future<dynamic> apiGetRequest(String url, {bool decode = true}) async {
    var client = http.Client();
    try {
      final response = await http.get(Uri.parse('$localHost$url'));
      if (response.statusCode == 403) {
        print("Status code: ${response.statusCode}");
        return false;
      }
      if (response.statusCode == 204 || response.statusCode == 200) {
        if (decode) {
          return json.decode(response.body);
        } else {
          return response.body;
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<dynamic> apiPostRequest(String url, var jsonMap, {bool decode = true}) async {
    var client = http.Client();
    try {
      final response = await http.post(Uri.parse('$localHost$url'),
          // headers: {
          //   'Content-type': 'application/json',
          //   'Accept': 'application/json',
          // },
          body: jsonMap);
      if (response.statusCode == 403 || response.statusCode == 500) {
        print(response.body);
        return false;
      }
      if (response.statusCode == 204 || response.statusCode == 200) {
        if (decode) {
          return json.decode(response.body);
        } else {
          return response.body;
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<dynamic> apiPostRequestNewProgram(String url, var jsonMap,
      {bool decode = true}) async {
    var client = http.Client();
    try {
      final response = await http.post(Uri.parse('$localHost$url'),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonMap);
      if (response.statusCode == 403 || response.statusCode == 500) {
        print(response.body);
        return false;
      }
      if (response.statusCode == 204 || response.statusCode == 200) {
        if (decode) {
          return json.decode(response.body);
        } else {
          return response.body;
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<dynamic> apiPutRequest(String url, var jsonMap, {bool decode = true}) async {
    var client = http.Client();
    try {
      final response = await http.put(Uri.parse('$localHost$url'),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonMap);
      if (response.statusCode == 403 || response.statusCode == 500) {
        print(response.body);
        return false;
      }
      if (response.statusCode == 204 || response.statusCode == 200) {
        if (decode) {
          return json.decode(response.body);
        } else {
          return response.body;
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      client.close();
    }
  }
}
