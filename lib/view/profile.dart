import 'package:absennyok/model/register_model.dart';
import 'package:absennyok/preferences/preferences_handler.dart';
import 'package:absennyok/services/api.dart';
import 'package:absennyok/view/login.dart';
import 'package:absennyok/widget/buttonmenu.dart';
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
                Text(
                  "Batch : ${user?.batch?.batchKe ?? "-"}",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "Training : ${user?.training?.title ?? "-"}",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          menuItem(
            icon: Icons.edit,
            text: "Edit Profile",
            onTap: () {
              final nameController = TextEditingController(
                text: user?.name ?? "",
              );
              final parentContext = context;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: const Text("Edit Profile"),
                    content: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Nama",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Batal"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: const Text("Simpan"),
                        onPressed: () async {
                          final newName = nameController.text.trim();

                          if (newName.isEmpty) return;

                          Navigator.pop(context); // tutup dialog

                          final token = await PreferenceHandler.getToken();

                          try {
                            final result = await AuthAPI.UpdateProfile(
                              nama: newName,
                              token: token!,
                            );

                            // Update UI
                            setState(() {
                              user = result.data!.user;
                            });

                            // Notifikasi success
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              const SnackBar(
                                content: Text("Profil berhasil diperbarui"),
                              ),
                            );

                            await loadProfile();
                          } catch (e) {
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              );
              // Arahkan ke halaman edit profile
              // context.push(EditProfile());
            },
          ),

          const SizedBox(height: 10),

          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextButton(
              onPressed: () {
                PreferenceHandler.removeLogin();
                PreferenceHandler.removeToken();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 14),
                  Text("Logout", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
