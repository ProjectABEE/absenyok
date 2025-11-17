import 'package:absennyok/view/home.dart';
import 'package:absennyok/view/kehadiran.dart';
import 'package:absennyok/view/profile.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int _currentIndex = 1;
  final List<Widget> _pages = [HomePage(), ProfilePage(), KehadiranPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle, // agar tab tengah bulat & menonjol
        backgroundColor: Colors.grey.shade900,
        color: Colors.grey.shade400, // warna ikon normal
        activeColor: Colors.teal, // warna ikon aktif
        items: [
          TabItem(icon: Icons.home_outlined, title: "Home"),
          TabItem(icon: Icons.person, title: "Profile"),
          TabItem(icon: Icons.fact_check_outlined, title: "Kehadiran"),
        ],
        initialActiveIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
