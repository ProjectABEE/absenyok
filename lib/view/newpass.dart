import 'package:absennyok/view/login.dart';
import 'package:absennyok/widget/costume_input.dart';
import 'package:flutter/material.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController passC = TextEditingController();
  final TextEditingController passC1 = TextEditingController();
  bool obscure1 = true;
  bool obscure2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BACKGROUND GRADIENT
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
          child: Column(
            children: [
              const SizedBox(height: 20),

              // HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  const Text(
                    "Presence App",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // CARD
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "New Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          "Masukkan kata sandi baru",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Password field
                        buildInputField(
                          controler: passC,
                          label: "Kata Sandi",
                          obscure: obscure1,
                          icon: Icons.lock_outline,
                          onSuffixTap: () {
                            setState(() {
                              obscure1 = !obscure1;
                            });
                          },
                          suffixIcon: obscure1
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),

                        const SizedBox(height: 18),

                        // Confirm password field
                        buildInputField(
                          controler: passC1,
                          label: "Konfirmasi Kata Sandi",
                          obscure: obscure2,
                          icon: Icons.lock_outline,
                          onSuffixTap: () {
                            setState(() {
                              obscure2 = !obscure2;
                            });
                          },
                          suffixIcon: obscure2
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),

                        const SizedBox(height: 30),

                        // BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              shadowColor: Colors.greenAccent.shade200,
                              elevation: 8,
                            ),
                            child: const Text(
                              "Create",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
