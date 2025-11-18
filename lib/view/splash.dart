import 'package:absennyok/preferences/preferences_handler.dart';
import 'package:absennyok/view/bottomnav.dart';
import 'package:absennyok/view/login.dart';
import 'package:flutter/material.dart';

class SplashScreenDay33 extends StatefulWidget {
  const SplashScreenDay33({super.key});

  @override
  State<SplashScreenDay33> createState() => _SplashScreenDay33State();
}

class _SplashScreenDay33State extends State<SplashScreenDay33> {
  @override
  void initState() {
    super.initState();
    isLoginFunction();
  }

  isLoginFunction() async {
    Future.delayed(Duration(seconds: 1)).then((value) async {
      var isLogin = await PreferenceHandler.getLogin();
      print(isLogin);
      if (isLogin != null && isLogin == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Bottomnav()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff256BE8), Color(0xff1CE2DA)],
          ),
        ),
        // Biar full tinggi layar
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // children: [Center(child: Image.asset("assets/images/logoEdu.png"))],
        ),
      ),
    );
  }
}
