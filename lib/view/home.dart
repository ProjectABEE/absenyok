import 'package:absennyok/model/historytoday.dart';
import 'package:absennyok/model/register_model.dart';
import 'package:absennyok/model/statistik.dart';
import 'package:absennyok/services/api.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Statistic? statistic;
  HistoryToday? historyToday;
  bool isHistoryLoading = true;

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning! 👋";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon! 👋";
    } else if (hour >= 17 && hour < 20) {
      return "Good Evening 🌆";
    } else {
      return "Good Night 🌙";
    }
  }

  bool isLoadingIn = false;
  bool isLoadingOut = false;
  User? user;
  GoogleMapController? _googleMapController;
  LatLng _currentPosition = LatLng(-6.2000, 108.816666);
  String _currentAddress = "Alamat tidak ditemukan";

  Marker? _marker;
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
    loadProfile();
    getTodayHistory();
    loadStatistic();
  }

  loadStatistic() async {
    try {
      final data = await AuthAPI.getStatistic();
      setState(() => statistic = data);
    } catch (e) {
      print("Error statistic: $e");
    }
  }

  getTodayHistory() async {
    try {
      final result = await AuthAPI.getHistoryToday();
      setState(() {
        historyToday = result;
        isHistoryLoading = false;
      });
    } catch (e) {
      print("ERROR HISTORY: $e");
      setState(() => isHistoryLoading = false);
    }
  }

  loadProfile() async {
    try {
      final result = await AuthAPI.getProfile();
      setState(() {
        user = result;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _currentPosition = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );
    Placemark place = placemarks[0];

    setState(() {
      _marker = Marker(
        markerId: const MarkerId("lokasi_saya"),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: "Lokasi Anda",
          snippet: "${place.street}, ${place.locality}",
        ),
      );

      _currentAddress =
          "${place.name}, ${place.street}, ${place.locality}, ${place.country}, ${place.postalCode}";

      _googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 16),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe8e8e8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top grey gradient background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 70, bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff9e9e9e), Color(0xffc9c9c9)],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    getGreeting(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    user?.name ?? "Loading...",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    user?.email ?? "Loading...",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // LOCATION + CHECK IN/OUT CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xffe2e2e2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _currentAddress,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() => isLoadingIn = true);

                          try {
                            Position pos = await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high,
                            );

                            double lat = pos.latitude;
                            double lng = pos.longitude;

                            // DATE & TIME
                            String attendanceDate = DateFormat(
                              "yyyy-MM-dd",
                            ).format(DateTime.now()); // format utk API
                            String timeNow = DateFormat(
                              "HH:mm",
                            ).format(DateTime.now());

                            final response = await AuthAPI.checkIn(
                              attendanceDate: attendanceDate,
                              CheckInTime: timeNow,
                              checkInLat: lat,
                              checkInLng: lng,
                              checkInAddress: _currentAddress,
                              status: "masuk",
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  response.message ?? "Check-in berhasil",
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Gagal Check-in: $e")),
                            );
                          }

                          setState(() => isLoadingIn = false);
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          isLoadingIn ? "Loading..." : "Check In",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      ElevatedButton(
                        onPressed: () async {
                          setState(() => isLoadingOut = true);

                          try {
                            Position pos = await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high,
                            );

                            double lat = pos.latitude;
                            double lng = pos.longitude;

                            // DATE & TIME
                            String attendanceDate = DateFormat(
                              "yyyy-MM-dd",
                            ).format(DateTime.now()); // format utk API
                            String timeNow = DateFormat(
                              "HH:mm",
                            ).format(DateTime.now());

                            final response = await AuthAPI.checkOut(
                              attendanceDate: attendanceDate,
                              CheckInTime: timeNow,
                              checkInLat: lat,
                              checkInLng: lng,
                              checkInAddress: _currentAddress,
                              status: "masuk",
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  response.message ?? "Check-Out berhasil",
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Gagal Check-in: $e")),
                            );
                          }

                          setState(() => isLoadingOut = false);
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          isLoadingOut ? "Loading..." : "Check Out",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Distance + Map
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.only(left: 18, right: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xffb6b6b6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Distance from place",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "↯ 250.43m",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _getCurrentLocation();
                          },
                          child: Text("Refresh "),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 18, left: 10),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade300,
                    ),
                    child: GoogleMap(
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition,
                        zoom: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Riwayat Kehadiran
            const Text(
              "Riwayat Kehadiran",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: isHistoryLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (historyToday?.data == null
                        ? const Center(
                            child: Text(
                              "Belum ada absensi hari ini",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat.EEEE('id_ID').format(
                                      historyToday!.data!.attendanceDate!,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd MMM yyyy', 'id_ID').format(
                                      historyToday!.data!.attendanceDate!,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text("Check In"),
                                  Text(historyToday!.data!.checkInTime ?? "-"),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text("Check Out"),
                                  Text(historyToday!.data!.checkOutTime ?? "-"),
                                ],
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          )),
            ),

            const SizedBox(height: 15),

            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Text(
                  "Lihat Semua",
                  style: TextStyle(color: Colors.blue.shade800, fontSize: 13),
                ),
              ),
            ),

            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: statistic == null
                  ? const Center(child: Text("Memuat statistik..."))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Statistik Kehadiran",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _statItem(
                              "Total Absen",
                              "${statistic!.data?.totalAbsen ?? 0}",
                            ),
                            _statItem(
                              "Masuk",
                              "${statistic!.data?.totalMasuk ?? 0}",
                            ),
                            _statItem(
                              "Izin",
                              "${statistic!.data?.totalIzin ?? 0}",
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Icon(
                              statistic!.data?.sudahAbsenHariIni == true
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: statistic!.data?.sudahAbsenHariIni == true
                                  ? Colors.green
                                  : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              statistic!.data?.sudahAbsenHariIni == true
                                  ? "Sudah absen hari ini"
                                  : "Belum absen hari ini",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}
