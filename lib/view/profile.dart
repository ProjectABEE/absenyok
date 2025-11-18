import 'package:absennyok/model/register_model.dart';
import 'package:absennyok/preferences/preferences_handler.dart';
import 'package:absennyok/services/api.dart';
import 'package:absennyok/view/login.dart';
import 'package:absennyok/widget/menutile.dart';
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
      setState(() => user = result);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1a1a1a),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ---- HEADER ----
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white.withOpacity(.2)),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white.withOpacity(.2),
                      child: const Icon(
                        Icons.person,
                        size: 55,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      user?.name ?? "Loading...",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      user?.email ?? "Loading...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(.7),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Batch: ${user?.batch?.batchKe ?? "-"}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(.8),
                      ),
                    ),
                    Text(
                      "Training: ${user?.training?.title ?? "-"}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ---- MENU EDIT PROFILE ----
              menuTile(
                icon: Icons.edit,
                title: "Edit Profile",
                onTap: () => _showEditDialog(context),
              ),

              const SizedBox(height: 12),

              // ---- MENU LOGOUT ----
              menuTile(
                icon: Icons.logout,
                title: "Logout",
                iconColor: Colors.redAccent,
                textColor: Colors.redAccent,
                onTap: () {
                  PreferenceHandler.removeLogin();
                  PreferenceHandler.removeToken();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(text: user?.name ?? "");

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xff2B2B2B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Edit Profile",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Nama Baru",
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.greenAccent.shade400),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Batal", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade400,
              ),
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isEmpty) return;

                Navigator.pop(context);

                final token = await PreferenceHandler.getToken();

                try {
                  final result = await AuthAPI.UpdateProfile(
                    nama: newName,
                    token: token!,
                  );

                  setState(() => user = result.data!.user);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Nama berhasil diperbarui")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
