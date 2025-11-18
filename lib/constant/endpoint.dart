class Endpoint {
  static const String baseUrl = "https://appabsensi.mobileprojp.com/api";
  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String profile = "$baseUrl/profile";
  static const String checkin = "$baseUrl/absen/check-in";
  static const String checkout = "$baseUrl/absen/check-out";
  static const String historyToday =
      "$baseUrl/absen/today?attendance_date=2025-11-18";
  static const String statistic =
      "$baseUrl/absen/stats?start=2025-07-31&end=2025-12-31";
  static const String historyAbsen = "$baseUrl/absen/history";
}
