import 'package:absennyok/extension/navigator.dart';
import 'package:absennyok/model/register_model.dart';
import 'package:absennyok/services/api.dart';
import 'package:absennyok/view/login.dart';
import 'package:absennyok/widget/costume_input.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Register user = Register();
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  bool obscurePass = true;
  final TextEditingController namaC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  String? genderValue; // L / P
  int? batchValue; // 1 - 4
  int? trainingValue; // 1 - 15
  final List<Map<String, dynamic>> jurusanList = [
    {"id": 1, "title": "Data Management Staff (Operator Komputer)"},
    {"id": 2, "title": "Bahasa Inggris"},
    {"id": 3, "title": "Desainer Grafis Madya"},
    {"id": 4, "title": "Tata Boga"},
    {"id": 5, "title": "Tata Busana"},
    {"id": 6, "title": "Perhotelan"},
    {"id": 7, "title": "Teknisi Komputer"},
    {"id": 8, "title": "Teknisi Jaringan"},
    {"id": 9, "title": "Barista"},
    {"id": 10, "title": "Bahasa Korea"},
    {"id": 11, "title": "Make Up Artist"},
    {"id": 12, "title": "Desainer Multimedia"},
    {"id": 13, "title": "Content Creator"},
    {"id": 14, "title": "Web Programming"},
    {"id": 15, "title": "Digital Marketing"},
    {"id": 16, "title": "Mobile Programming"},
    {"id": 17, "title": "Akuntansi Junior"},
    {"id": 18, "title": "Konstruksi Bangunan dengan CAD"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BACKGROUND GRADIENT SAMA SEPERTI LOGIN
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BACK BUTTON + TITLE
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Presence App",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 12),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // CARD GLASS EFFECT
                  Container(
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
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: const Text(
                              "Register Account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              "Create your new account",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // NAMA
                          buildInputField(
                            controler: namaC,
                            label: "Nama",
                            icon: Icons.person_outline,
                            obscure: false,
                          ),
                          const SizedBox(height: 18),

                          // EMAIL
                          buildInputField(
                            controler: emailC,
                            label: "Email",
                            icon: Icons.email_outlined,
                            obscure: false,
                          ),
                          const SizedBox(height: 18),

                          // PASSWORD
                          buildInputField(
                            controler: passC,
                            label: "Kata Sandi",
                            icon: Icons.lock_outline,
                            obscure: obscurePass,
                            suffixIcon: obscurePass
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onSuffixTap: () {
                              setState(() {
                                obscurePass = !obscurePass;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          // JENIS KELAMIN DROPDOWN
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.09),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                dropdownColor: Colors.black87,
                                value: genderValue,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white70,
                                ),
                                hint: Text(
                                  "Jenis Kelamin",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: "L",
                                    child: Text("Laki - Laki"),
                                  ),
                                  DropdownMenuItem(
                                    value: "P",
                                    child: Text("Perempuan"),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() => genderValue = value);
                                },
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // BATCH DROPDOWN
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.09),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                isExpanded: true,
                                dropdownColor: Colors.black87,
                                value: batchValue,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white70,
                                ),
                                hint: const Text(
                                  "Batch",
                                  style: TextStyle(color: Colors.white70),
                                ),

                                items: List.generate(
                                  4,
                                  (i) => DropdownMenuItem<int>(
                                    value: i + 1, // 🔥 INT VALUE
                                    child: Text(
                                      "Batch ${i + 1}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                onChanged: (value) =>
                                    setState(() => batchValue = value),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // TRAINING DROPDOWN
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.09),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                isExpanded: true,
                                dropdownColor: Colors.black87,
                                value: trainingValue,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white70,
                                ),
                                hint: const Text(
                                  "Training / Jurusan",
                                  style: TextStyle(color: Colors.white70),
                                ),

                                items: jurusanList.map((item) {
                                  return DropdownMenuItem<int>(
                                    value: item["id"], // 🔥 INT VALUE
                                    child: Text(
                                      item["title"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),

                                onChanged: (value) =>
                                    setState(() => trainingValue = value),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // BUTTON REGISTER
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 8,
                                shadowColor: Colors.greenAccent.shade200,
                              ),
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  try {
                                    final result = await AuthAPI.registerUser(
                                      email: emailC.text,
                                      name: namaC.text,
                                      password: passC.text,
                                      jeniskelamin: genderValue,
                                      batchid: batchValue,
                                      trainingid: trainingValue,
                                    );

                                    print(result);

                                    // PINDAH HALAMAN DI SINI
                                    context.pushReplacement(LoginPage());

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Daftar Berhasil"),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                }
                              },

                              child: const Text(
                                "Register",
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
