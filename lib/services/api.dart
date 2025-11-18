import 'dart:convert';
import 'dart:developer';

import 'package:absennyok/constant/endpoint.dart';
import 'package:absennyok/model/absen.dart';
import 'package:absennyok/model/register_model.dart';
import 'package:absennyok/preferences/preferences_handler.dart';
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

  static Future<User> getProfile() async {
    final String? token = await PreferenceHandler.getToken();
    if (token == null) {
      throw Exception("Token tidak ditemukan. User belum login.");
    }

    final url = Uri.parse(Endpoint.profile);

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("PROFILE RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return User.fromJson(jsonData["data"]);
    } else {
      throw Exception("Gagal mengambil data profile");
    }
  }

  static Future<Checkin> checkIn({
    required DateTime attendanceDate,
    required String CheckInTime,
    required double checkInLat,
    required double checkInLng,
    required String checkInAddress,
    required String status,
  }) async {
    final url = Uri.parse(Endpoint.register);
    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {
        "attendance_date": attendanceDate,
        "check_in": CheckInTime,
        "check_in_lat": checkInLat,
        "check_in_lng": checkInLng,
        "check_in_address": checkInAddress,
        "status": status,
      },
    );
    print(response.body);
    print(response.statusCode);
    log(response.body);
    if (response.statusCode == 200) {
      return Checkin.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"]);
    }
  }
}
