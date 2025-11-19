import 'package:absennyok/model/historytoday.dart';
import 'package:absennyok/model/register_model.dart';
import 'package:absennyok/model/statistik.dart';
import 'package:absennyok/services/api.dart';
import 'package:absennyok/widget/glass.dart';
import 'package:absennyok/widget/stat.dart';
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff2E2E2E), Color(0xff1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GREETING + USER INFO
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreeting(),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user?.name ?? "Loading...",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        user?.email ?? "",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),

                // GLASS CARD — LOCATION + CHECK BUTTONS
                glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // BUTTON CHECK IN / OUT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // --- BUTTON CHECK IN ---
                          ElevatedButton(
                            onPressed: () async {
                              setState(() => isLoadingIn = true);

                              try {
                                Position pos =
                                    await Geolocator.getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high,
                                    );

                                double lat = pos.latitude;
                                double lng = pos.longitude;

                                String attendanceDate = DateFormat(
                                  "yyyy-MM-dd",
                                ).format(DateTime.now());
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

                                getTodayHistory(); // reload riwayat
                                loadStatistic(); // update statistik
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Gagal Check-in: $e")),
                                );
                              }

                              setState(() => isLoadingIn = false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent.shade400,
                              shadowColor: Colors.greenAccent.withOpacity(0.3),
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 14,
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

                          // --- BUTTON CHECK OUT ---
                          ElevatedButton(
                            onPressed: () async {
                              setState(() => isLoadingOut = true);

                              try {
                                Position pos =
                                    await Geolocator.getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high,
                                    );

                                double lat = pos.latitude;
                                double lng = pos.longitude;

                                String attendanceDate = DateFormat(
                                  "yyyy-MM-dd",
                                ).format(DateTime.now());
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

                                getTodayHistory();
                                loadStatistic();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Gagal Check-Out: $e"),
                                  ),
                                );
                              }

                              setState(() => isLoadingOut = false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade300,
                              elevation: 6,
                              shadowColor: Colors.blue.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 14,
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

                const SizedBox(height: 20),

                // GLASS CARD — MAP PREVIEW
                glassCard(
                  child: SizedBox(
                    height: 220,
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: GoogleMap(
                              myLocationEnabled: true,
                              initialCameraPosition: CameraPosition(
                                target: _currentPosition,
                                zoom: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _getCurrentLocation();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          child: const Text("Refresh Location"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // GLASS CARD — TODAY HISTORY
                glassCard(
                  child: historyToday == null
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Today's Attendance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      historyToday?.data?.checkInTime ?? "-",
                                      style: const TextStyle(
                                        color: Colors.greenAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Text(
                                      "Check In",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      historyToday?.data?.checkOutTime ?? "-",
                                      style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Text(
                                      "Check Out",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 20),

                // GLASS CARD — STATISTIC
                glassCard(
                  child: statistic == null
                      ? const Center(
                          child: Text(
                            "Loading statistik...",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Attendance Statistics",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                statBox(
                                  "Absen",
                                  "${statistic!.data?.totalAbsen ?? 0}",
                                ),
                                statBox(
                                  "Masuk",
                                  "${statistic!.data?.totalMasuk ?? 0}",
                                ),
                                statBox(
                                  "Izin",
                                  "${statistic!.data?.totalIzin ?? 0}",
                                ),
                              ],
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
