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
    loadHistoryAbsen(); // 👈 Tambah ini
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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
          ],
        ),
        child: historyAbsen == null || isLoadingHistory
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              )
            : historyAbsen!.data!.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Belum ada riwayat absensi",
                  style: TextStyle(fontSize: 15),
                ),
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: historyAbsen!.data!.length,
                itemBuilder: (context, index) {
                  final item = historyAbsen!.data![index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.EEEE(
                                'id',
                              ).format(item.attendanceDate!),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat(
                                'dd-MM-yyyy',
                              ).format(item.attendanceDate!),
                            ),
                          ],
                        ),

                        const Spacer(),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Check In"),
                            Text(item.checkInTime ?? "-"),
                          ],
                        ),

                        const SizedBox(width: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Check Out"),
                            Text(item.checkOutTime ?? "-"),
                          ],
                        ),

                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
