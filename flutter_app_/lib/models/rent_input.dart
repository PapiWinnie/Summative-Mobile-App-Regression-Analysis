/// Model class representing the input data for rent prediction
class RentInput {
  final double bathrooms;
  final double bedrooms;
  final double squareFeet;
  final double latitude;
  final double longitude;
  final String category;
  final String condition;    // maps to backend 'condition'
  final String isFurnished;  // maps to backend 'is_furnished'
  final String parkingSpace; // maps to backend 'parking_space'

  RentInput({
    required this.bathrooms,
    required this.bedrooms,
    required this.squareFeet,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.condition,
    required this.isFurnished,
    required this.parkingSpace,
  });

  /// Convert the model to JSON format for API request
  Map<String, dynamic> toJson() {
    return {
      'bathrooms': bathrooms,
      'bedrooms': bedrooms,
      'floor_area': squareFeet,
      'lat': latitude,
      'lng': longitude,
      'category': category,
      'condition': condition,
      'is_furnished': isFurnished,
      'parking_space': parkingSpace,
    };
  }
}

/// Model class for the API response
class RentPredictionResponse {
  final double predictedRent;
  final String? error;

  RentPredictionResponse({
    required this.predictedRent,
    this.error,
  });

  factory RentPredictionResponse.fromJson(Map<String, dynamic> json) {
    return RentPredictionResponse(
      predictedRent: (json['predicted_rent'] ?? 0.0).toDouble(),
      error: json['error'],
    );
  }
}
