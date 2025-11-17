/// Model class representing the input data for rent prediction
class RentInput {
  final double bathrooms;
  final double bedrooms;
  final double squareFeet;
  final double latitude;
  final double longitude;
  final String category;
  final String priceType;
  final String hasPhoto;
  final String petsAllowed;

  RentInput({
    required this.bathrooms,
    required this.bedrooms,
    required this.squareFeet,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.priceType,
    required this.hasPhoto,
    required this.petsAllowed,
  });

  /// Convert the model to JSON format for API request
  Map<String, dynamic> toJson() {
    return {
      'bathrooms': bathrooms,
      'bedrooms': bedrooms,
      'square_feet': squareFeet,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'price_type': priceType,
      'has_photo': hasPhoto,
      'pets_allowed': petsAllowed,
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

  /// Parse the API response JSON
  factory RentPredictionResponse.fromJson(Map<String, dynamic> json) {
    return RentPredictionResponse(
      predictedRent: (json['predicted_rent'] ?? 0.0).toDouble(),
      error: json['error'],
    );
  }
} 