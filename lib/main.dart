import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:inedit/constants/colors.dart';
import 'package:inedit/routes/start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InEdit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        fontFamily: "Giga",
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.transparent

      ),
      home: Start(),
      builder: EasyLoading.init(),
    );
  }
}
