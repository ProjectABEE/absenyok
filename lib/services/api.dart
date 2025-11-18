import 'dart:convert';
import 'dart:developer';

import 'package:absennyok/constant/endpoint.dart';
import 'package:absennyok/model/absenHistory.dart';
import 'package:absennyok/model/checkin.dart';
import 'package:absennyok/model/checkout.dart';
import 'package:absennyok/model/historytoday.dart';
import 'package:absennyok/model/register_model.dart';
import 'package:absennyok/model/statistik.dart';
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
    required String attendanceDate,
    required String CheckInTime,
    required double checkInLat,
    required double checkInLng,
    required String checkInAddress,
    required String status,
  }) async {
    final String? token = await PreferenceHandler.getToken();
    final url = Uri.parse(Endpoint.checkin);
    final response = await http.post(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {
        "attendance_date": attendanceDate,
        "check_in": CheckInTime,
        "check_in_lat": checkInLat.toString(),
        "check_in_lng": checkInLng.toString(),
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

  static Future<CheckOut> checkOut({
    required String attendanceDate,
    required String CheckInTime,
    required double checkInLat,
    required double checkInLng,
    required String checkInAddress,
    required String status,
  }) async {
    final String? token = await PreferenceHandler.getToken();
    final url = Uri.parse(Endpoint.checkout);
    final response = await http.post(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {
        "attendance_date": attendanceDate,
        "check_out": CheckInTime,
        "check_out_lat": checkInLat.toString(),
        "check_out_lng": checkInLng.toString(),
        "check_out_address": checkInAddress,
        "status": status,
      },
    );
    print(response.body);
    print(response.statusCode);
    log(response.body);
    if (response.statusCode == 200) {
      return CheckOut.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"]);
    }
  }

  static Future<HistoryToday> getHistoryToday() async {
    final String? token = await PreferenceHandler.getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    final url = Uri.parse(Endpoint.historyToday);

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("RAW HISTORY: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return HistoryToday.fromJson(jsonData);
    } else {
      throw Exception("Gagal mengambil data hari ini");
    }
  }

  static Future<Statistic> getStatistic() async {
    final String? token = await PreferenceHandler.getToken();
    if (token == null) {
      throw Exception("Token tidak ditemukan. User belum login.");
    }

    final url = Uri.parse(Endpoint.statistic); // pastikan endpointnya benar

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("STATISTIC RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Statistic.fromJson(jsonData);
    } else {
      throw Exception("Gagal mengambil statistik");
    }
  }

  static Future<HistoryAbsen> getHistoryAbsen() async {
    final String? token = await PreferenceHandler.getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    final url = Uri.parse(Endpoint.historyAbsen);

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("HISTORY ABSEN RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return HistoryAbsen.fromJson(jsonData);
    } else {
      throw Exception("Gagal mengambil history absen");
    }
  }

  static Future<Register> UpdateProfile({
    required String nama,
    required String token,
  }) async {
    final url = Uri.parse(Endpoint.profile);
    final response = await http.put(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      body: {"name": nama},
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
