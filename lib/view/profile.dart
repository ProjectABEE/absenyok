import 'package:absennyok/model/register_model.dart';
import 'package:absennyok/services/api.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  @override
  void initState() {
    super.initState();
    loadProfile();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e5e5),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 80, bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff9e9e9e), Color(0xffc9c9c9)],
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 70, color: Colors.grey),
                ),
                SizedBox(height: 15),
                Text(
                  user?.name ?? "Loading...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? "Loading...",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          _menuTile(Icons.person_outline, "Ubah Profil"),
          _menuTile(Icons.lock_outline, "Ubah Kata Sandi"),

          const SizedBox(height: 10),

          _menuTile(Icons.logout, "Keluar", color: Colors.red),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String title, {Color color = Colors.black}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xffcccccc),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(title, style: TextStyle(fontSize: 16, color: color)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }
}
