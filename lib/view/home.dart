import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final LatLng _officeLocation = const LatLng(3.589328, 98.673825);

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
                children: const [
                  Text(
                    "Good Morning!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text("Muhammad Rio Akbar", style: TextStyle(fontSize: 16)),
                  Text("123456789", style: TextStyle(fontSize: 13)),
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
                          "Jl. Pangeran Diponegoro No 5, Kec. Medan Petisah, Kota Medan, Sumatra Utara",
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
                    children: [
                      Expanded(child: _timeCard("Check In", "07 : 50 : 00")),
                      const SizedBox(width: 12),
                      Expanded(child: _timeCard("Check Out", "17 : 50 : 00")),
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
                    height: 120,
                    margin: const EdgeInsets.only(left: 18, right: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xffb6b6b6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _officeLocation,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId("office"),
                            position: _officeLocation,
                          ),
                        },
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
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
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Monday",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("13-Jun-25"),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [Text("Check In"), Text("07 : 50 : 00")],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [Text("Check Out"), Text("17 : 50 : 00")],
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
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
          ],
        ),
      ),
    );
  }

  Widget _timeCard(String title, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xff6ea89c),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
