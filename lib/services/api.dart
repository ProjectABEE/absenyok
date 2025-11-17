import 'dart:convert';
import 'dart:developer';

import 'package:absennyok/constant/endpoint.dart';
import 'package:absennyok/model/register_model.dart';
import 'package:http/http.dart' as http;

class AuthAPI {
  static Future<Register> registerUser({
    required String email,
    required String name,
    required String password,
    required String? jeniskelamin,
    required int? batchid,
    required int? trainingid,
  }) async {
    final url = Uri.parse(Endpoint.register);
    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {
        "name": name,
        "email": email,
        "password": password,
        "jenis_kelamin": jeniskelamin?.toString(),
        "batch_id": batchid?.toString(),
        "training_id": trainingid?.toString(),
      },
    );
    print(response.body);
    print(response.statusCode);
    log(response.body);
    if (response.statusCode == 200) {
      return Register.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"]);
    }
  }

  static Future<Register> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login);
    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    log(response.body);
    if (response.statusCode == 200) {
      return Register.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"]);
    }
  }
}
