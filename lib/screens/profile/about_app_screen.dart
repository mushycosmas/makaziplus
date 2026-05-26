import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About App"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Makazi Plus is a real estate platform where users can buy, sell, and manage properties easily in Tanzania.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}