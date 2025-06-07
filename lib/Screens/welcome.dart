import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_quanlythuchi/Screens/login.dart';
import 'package:flutter_quanlythuchi/Screens/signup.dart';

class MyWelcome extends StatelessWidget {
  const MyWelcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _welcomeLabel("Welcome", const Color(0xff909090)),
                  const SizedBox(height: 20),
                  _logo(),
                  const SizedBox(height: 20),
                  _mainButton("Đăng nhập", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    );
                  }),
                  const SizedBox(height: 15),
                  _mainButton("Đăng ký", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterPage()),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainButton(String text, VoidCallback onPress) {
    return Container(
      width: 300,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF7C4DFF),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: TextButton(
        onPressed: onPress,
        child: Text(
          text,
          style: GoogleFonts.josefinSans(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _welcomeLabel(String label, Color textColor) {
    return Text(
      label,
      style: GoogleFonts.josefinSans(
        textStyle: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 35,
        ),
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: SvgPicture.asset("images/welcome.svg"),
      ),
    );
  }
}
