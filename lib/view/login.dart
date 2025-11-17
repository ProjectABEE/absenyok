import 'package:absennyok/extension/navigator.dart';
import 'package:absennyok/model/register_model.dart';
import 'package:absennyok/preferences/preferences_handler.dart';
import 'package:absennyok/services/api.dart';
import 'package:absennyok/view/bottomnav.dart';
import 'package:absennyok/view/daftar.dart';
import 'package:absennyok/view/resetpass.dart';
import 'package:absennyok/widget/costume_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  bool obscurePass = true;
  bool isLoading = false;
  Register user = Register();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // GRADIENT BACKGROUND
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // TITLE
                  const Text(
                    "Presence App",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 12)],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // CARD GLASS EFFECT
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(25),
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
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Login to your account",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // EMAIL FIELD
                          buildInputField(
                            controler: emailC,
                            label: "Email",
                            icon: Icons.email_outlined,
                            obscure: false,
                          ),
                          const SizedBox(height: 18),

                          // PASSWORD FIELD
                          buildInputField(
                            controler: passC,
                            label: "Kata Sandi",
                            icon: Icons.lock_outline,
                            obscure: obscurePass,
                            onSuffixTap: () {
                              setState(() {
                                obscurePass = !obscurePass;
                              });
                            },
                            suffixIcon: obscurePass
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),

                          const SizedBox(height: 30),

                          // LOGIN BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    // Call API
                                    final Register result =
                                        await AuthAPI.loginUser(
                                          email: emailC.text,
                                          password: passC.text,
                                        );
                                    PreferenceHandler.saveLogin(true);
                                    setState(() {
                                      isLoading = false;
                                      user = result; // simpan model login
                                    });

                                    // Simpan token ke local storage
                                    PreferenceHandler.saveToken(
                                      result.data!.token!,
                                    );

                                    print(
                                      "LOGIN SUCCESS: ${result.data!.token}",
                                    );

                                    // Pindah halaman
                                    context.pushReplacement(Bottomnav());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Login Berhasil")),
                                    );
                                  } catch (e) {
                                    setState(() => isLoading = false);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Validasi eror"),
                                        content: Text(
                                          "Tolong isi semua dengan benar",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Ok"),
                                          ),
                                          // TextButton(
                                          //   onPressed: () {
                                          //     Navigator.pop(context);
                                          //   },
                                          //   child: Text("Ga Ok"),
                                          // ),
                                        ],
                                      );
                                    },
                                  );
                                }
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
                                "Log In",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // FORGOT PASSWORD
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResetPasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Lupa Kata Sandi?",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // REGISTER LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun? ",
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.greenAccent.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
