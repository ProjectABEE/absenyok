import 'package:absennyok/model/absenHistory.dart';
import 'package:absennyok/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KehadiranPage extends StatefulWidget {
  const KehadiranPage({super.key});

  @override
  State<KehadiranPage> createState() => _KehadiranPageState();
}

class _KehadiranPageState extends State<KehadiranPage> {
  HistoryAbsen? historyAbsen;
  bool isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    loadHistoryAbsen();
  }

  loadHistoryAbsen() async {
    try {
      final data = await AuthAPI.getHistoryAbsen();
      setState(() {
        historyAbsen = data;
        isLoadingHistory = false;
      });
    } catch (e) {
      print(e);
      setState(() => isLoadingHistory = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BACKGROUND GRADIENT SAMA TEMA APP
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE / APPBAR SIMPLE
                const Text(
                  "Riwayat Kehadiran",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Lihat daftar absensi kamu",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 18),

                // CARD GLASS UTAMA BERISI LIST
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: _buildHistoryContent(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryContent() {
    if (isLoadingHistory || historyAbsen == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (historyAbsen!.data == null || historyAbsen!.data!.isEmpty) {
      return const Center(
        child: Text(
          "Belum ada riwayat absensi",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      );
    }

    return ListView.separated(
      itemCount: historyAbsen!.data!.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = historyAbsen!.data![index];

        final dayName = item.attendanceDate != null
            ? DateFormat.EEEE('id').format(item.attendanceDate!)
            : "-";

        final dateString = item.attendanceDate != null
            ? DateFormat('dd-MM-yyyy').format(item.attendanceDate!)
            : "-";

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Row(
            children: [
              // TANGGAL
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    dateString,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // CHECK IN
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Check In",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    item.checkInTime ?? "-",
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              // CHECK OUT
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Check Out",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    item.checkOutTime ?? "-",
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white.withOpacity(0.5),
              ),
            ],
          ),
        );
      },
    );
  }
}
