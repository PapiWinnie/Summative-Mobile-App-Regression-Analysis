import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rent_input.dart';

/// Service class to handle API communication
class ApiService {
  // TODO: Replace this placeholder URL with your actual API endpoint
  // For local testing: http://10.0.2.2:8000/predict (Android emulator)
  // For local testing: http://localhost:8000/predict (iOS simulator)
  // For deployed API: https://your-api-domain.com/predict
  static const String baseUrl = 'http://127.0.0.1:8000/predict';
 
  /// Send a POST request to predict rent based on input data
  /// Returns a RentPredictionResponse with the predicted rent or error message
  Future<RentPredictionResponse> predictRent(RentInput input) async {
    try {
      // Make POST request to the API
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(input.toJson()),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = jsonDecode(response.body);
        return RentPredictionResponse.fromJson(data);
      } else {
        // Handle HTTP error responses
        return RentPredictionResponse(
          predictedRent: 0.0,
          error: 'Server error: ${response.statusCode}. ${response.body}',
        );
      }
    } catch (e) {
      // Handle network or parsing errors
      return RentPredictionResponse(
        predictedRent: 0.0,
        error: 'Failed to connect to API: $e',
      );
    }
  }
}