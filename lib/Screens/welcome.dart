import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MyWelcome extends StatelessWidget {
  const MyWelcome({super.key});

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
                children: [
                  SizedBox(),
                  const SizedBox(height: 20),
                  _welcomeLabel("Welcome", Color(0xff909090)),
                  const SizedBox(height: 20),
                  _logo(),
                  const SizedBox(height: 20),
                  _loginBtn((() => Navigator.pop(context))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _loginBtn(VoidCallback onPress) {
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
        "Logout",
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
