import 'package:flutter/material.dart';
import '../models/rent_input.dart';
import '../services/api_service.dart';
import '../widgets/form_field_widget.dart';

/// Main screen for rent prediction form
class RentFormScreen extends StatefulWidget {
  const RentFormScreen({Key? key}) : super(key: key);

  @override
  State<RentFormScreen> createState() => _RentFormScreenState();
}

class _RentFormScreenState extends State<RentFormScreen> {
  // Controllers for text input fields
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _squareFeetController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  // Dropdown field values
  String? _category;
  String? _priceType;
  String? _hasPhoto;
  String? _petsAllowed;

  // Validation error messages
  String? _bathroomsError;
  String? _bedroomsError;
  String? _squareFeetError;
  String? _latitudeError;
  String? _longitudeError;

  // State variables
  bool _isLoading = false;
  double? _predictedRent;
  String? _errorMessage;

  // API service instance
  final ApiService _apiService = ApiService();

  // Dropdown options
  final List<String> _categoryOptions = ['home', 'short_term'];
  final List<String> _priceTypeOptions = ['Monthly|Weekly', 'Weekly'];
  final List<String> _hasPhotoOptions = ['Thumbnail', 'Yes'];
  final List<String> _petsAllowedOptions = ['Cats,Dogs', 'Dogs', 'Unknown'];

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    _bathroomsController.dispose();
    _bedroomsController.dispose();
    _squareFeetController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  /// Validate numeric field with min/max range
  String? _validateNumericField(String value, double min, double max, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    final double? numValue = double.tryParse(value);
    if (numValue == null) {
      return 'Please enter a valid number';
    }
    if (numValue < min || numValue > max) {
      return 'Value must be between $min and $max';
    }
    return null;
  }

  /// Check if all form fields are valid
  bool _isFormValid() {
    return _bathroomsError == null &&
        _bedroomsError == null &&
        _squareFeetError == null &&
        _latitudeError == null &&
        _longitudeError == null &&
        _bathroomsController.text.isNotEmpty &&
        _bedroomsController.text.isNotEmpty &&
        _squareFeetController.text.isNotEmpty &&
        _latitudeController.text.isNotEmpty &&
        _longitudeController.text.isNotEmpty &&
        _category != null &&
        _priceType != null &&
        _hasPhoto != null &&
        _petsAllowed != null;
  }

  /// Handle form submission
  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
      _predictedRent = null;
      _errorMessage = null;
    });

    try {
      // Create RentInput object from form data
      final rentInput = RentInput(
        bathrooms: double.parse(_bathroomsController.text),
        bedrooms: double.parse(_bedroomsController.text),
        squareFeet: double.parse(_squareFeetController.text),
        latitude: double.parse(_latitudeController.text),
        longitude: double.parse(_longitudeController.text),
        category: _category!,
        priceType: _priceType!,
        hasPhoto: _hasPhoto!,
        petsAllowed: _petsAllowed!,
      );

      // Call API service to get prediction
      final response = await _apiService.predictRent(rentInput);

      setState(() {
        _isLoading = false;
        if (response.error != null) {
          _errorMessage = response.error;
        } else {
          _predictedRent = response.predictedRent;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Housing Rent Prediction'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[700]!, Colors.blue[50]!],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Property Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Bathrooms field
                        NumericFormField(
                          label: 'Bathrooms',
                          hint: 'Enter number of bathrooms (0-20)',
                          controller: _bathroomsController,
                          minValue: 0,
                          maxValue: 20,
                          errorText: _bathroomsError,
                          onChanged: (value) {
                            setState(() {
                              _bathroomsError = _validateNumericField(value, 0, 20, 'Bathrooms');
                            });
                          },
                        ),

                        // Bedrooms field
                        NumericFormField(
                          label: 'Bedrooms',
                          hint: 'Enter number of bedrooms (0-20)',
                          controller: _bedroomsController,
                          minValue: 0,
                          maxValue: 20,
                          errorText: _bedroomsError,
                          onChanged: (value) {
                            setState(() {
                              _bedroomsError = _validateNumericField(value, 0, 20, 'Bedrooms');
                            });
                          },
                        ),

                        // Square feet field
                        NumericFormField(
                          label: 'Square Feet',
                          hint: 'Enter area in sq ft (100-10000)',
                          controller: _squareFeetController,
                          minValue: 100,
                          maxValue: 10000,
                          errorText: _squareFeetError,
                          onChanged: (value) {
                            setState(() {
                              _squareFeetError = _validateNumericField(value, 100, 10000, 'Square feet');
                            });
                          },
                        ),

                        // Latitude field
                        NumericFormField(
                          label: 'Latitude',
                          hint: 'Enter latitude coordinate',
                          controller: _latitudeController,
                          minValue: -90,
                          maxValue: 90,
                          errorText: _latitudeError,
                          onChanged: (value) {
                            setState(() {
                              _latitudeError = _validateNumericField(value, -90, 90, 'Latitude');
                            });
                          },
                        ),

                        // Longitude field
                        NumericFormField(
                          label: 'Longitude',
                          hint: 'Enter longitude coordinate',
                          controller: _longitudeController,
                          minValue: -180,
                          maxValue: 180,
                          errorText: _longitudeError,
                          onChanged: (value) {
                            setState(() {
                              _longitudeError = _validateNumericField(value, -180, 180, 'Longitude');
                            });
                          },
                        ),

                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),

                        const Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Category dropdown
                        DropdownFormField(
                          label: 'Category',
                          value: _category,
                          items: _categoryOptions,
                          onChanged: (value) {
                            setState(() {
                              _category = value;
                            });
                          },
                        ),

                        // Price type dropdown
                        DropdownFormField(
                          label: 'Price Type',
                          value: _priceType,
                          items: _priceTypeOptions,
                          onChanged: (value) {
                            setState(() {
                              _priceType = value;
                            });
                          },
                        ),

                        // Has photo dropdown
                        DropdownFormField(
                          label: 'Has Photo',
                          value: _hasPhoto,
                          items: _hasPhotoOptions,
                          onChanged: (value) {
                            setState(() {
                              _hasPhoto = value;
                            });
                          },
                        ),

                        // Pets allowed dropdown
                        DropdownFormField(
                          label: 'Pets Allowed',
                          value: _petsAllowed,
                          items: _petsAllowedOptions,
                          onChanged: (value) {
                            setState(() {
                              _petsAllowed = value;
                            });
                          },
                        ),

                        const SizedBox(height: 24),

                        // Submit button
                        ElevatedButton(
                          onPressed: _isFormValid() && !_isLoading ? _submitForm : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue[700],
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Predict Rent',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Display prediction result
                if (_predictedRent != null)
                  PredictionResultCard(predictedRent: _predictedRent!),

                // Display error message
                if (_errorMessage != null)
                  ErrorMessageCard(errorMessage: _errorMessage!),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 