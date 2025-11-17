import 'package:flutter/material.dart';
import 'screens/rent_form.dart';

/// Entry point of the Flutter application
void main() {
  runApp(const StudentHousingRentPredictionApp());
}

/// Root widget of the application
class StudentHousingRentPredictionApp extends StatelessWidget {
  const StudentHousingRentPredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Housing Rent Prediction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const RentFormScreen(),
    );
  }
} 
