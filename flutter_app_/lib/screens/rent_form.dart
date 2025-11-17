import 'package:flutter/material.dart';
import '../models/rent_input.dart';
import '../services/api_service.dart';
import '../widgets/form_field_widget.dart';

class RentFormScreen extends StatefulWidget {
  const RentFormScreen({super.key});

  @override
  State<RentFormScreen> createState() => _RentFormScreenState();
}

class _RentFormScreenState extends State<RentFormScreen> {
  // Controllers for numeric input fields
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _squareFeetController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  // Dropdown selections
  String? _category;
  String? _condition;
  String? _isFurnished;
  String? _parkingSpace;

  // Error messages
  String? _bathroomsError;
  String? _bedroomsError;
  String? _squareFeetError;
  String? _latitudeError;
  String? _longitudeError;

  // State variables
  bool _isLoading = false;
  double? _predictedRent;
  String? _errorMessage;

  final ApiService _apiService = ApiService();

  // Dropdown options
  final List<String> _categoryOptions = ['home', 'short_term'];
  final List<String> _conditionOptions = ['new', 'used'];
  final List<String> _isFurnishedOptions = ['Yes', 'No'];
  final List<String> _parkingSpaceOptions = ['Yes', 'No'];

  @override
  void dispose() {
    _bathroomsController.dispose();
    _bedroomsController.dispose();
    _squareFeetController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  // Validate numeric fields
  String? _validateNumericField(String value, double min, double max, String fieldName) {
    if (value.isEmpty) return '$fieldName is required';
    final double? numValue = double.tryParse(value);
    if (numValue == null) return 'Enter a valid number';
    if (numValue < min || numValue > max) return 'Value must be between $min and $max';
    return null;
  }

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
        _condition != null &&
        _isFurnished != null &&
        _parkingSpace != null;
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
      _predictedRent = null;
      _errorMessage = null;
    });

    try {
      final rentInput = RentInput(
        bathrooms: double.parse(_bathroomsController.text),
        bedrooms: double.parse(_bedroomsController.text),
        squareFeet: double.parse(_squareFeetController.text),
        latitude: double.parse(_latitudeController.text),
        longitude: double.parse(_longitudeController.text),
        category: _category!,
        condition: _condition!,
        isFurnished: _isFurnished!,
        parkingSpace: _parkingSpace!,
      );

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
        _errorMessage = 'Unexpected error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Housing Rent Prediction'),
        backgroundColor: Colors.blue[700],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Property Details',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      NumericFormField(
                        label: 'Bathrooms',
                        hint: 'Enter number of bathrooms (1-20)',
                        controller: _bathroomsController,
                        minValue: 1,
                        maxValue: 20,
                        errorText: _bathroomsError,
                        onChanged: (value) {
                          setState(() {
                            _bathroomsError = _validateNumericField(value, 1, 20, 'Bathrooms');
                          });
                        },
                      ),
                      NumericFormField(
                        label: 'Bedrooms',
                        hint: 'Enter number of bedrooms (1-20)',
                        controller: _bedroomsController,
                        minValue: 1,
                        maxValue: 20,
                        errorText: _bedroomsError,
                        onChanged: (value) {
                          setState(() {
                            _bedroomsError = _validateNumericField(value, 1, 20, 'Bedrooms');
                          });
                        },
                      ),
                      NumericFormField(
                        label: 'Square Feet',
                        hint: 'Enter area in sq ft (50-10000)',
                        controller: _squareFeetController,
                        minValue: 50,
                        maxValue: 10000,
                        errorText: _squareFeetError,
                        onChanged: (value) {
                          setState(() {
                            _squareFeetError = _validateNumericField(value, 50, 10000, 'Square feet');
                          });
                        },
                      ),
                      NumericFormField(
                        label: 'Latitude',
                        hint: 'Enter latitude (-90 to 90)',
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
                      NumericFormField(
                        label: 'Longitude',
                        hint: 'Enter longitude (-180 to 180)',
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

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      const Text('Additional Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),

                      DropdownFormField(
                        label: 'Category',
                        value: _category,
                        items: _categoryOptions,
                        onChanged: (value) => setState(() => _category = value),
                      ),
                      DropdownFormField(
                        label: 'Condition',
                        value: _condition,
                        items: _conditionOptions,
                        onChanged: (value) => setState(() => _condition = value),
                      ),
                      DropdownFormField(
                        label: 'Is Furnished',
                        value: _isFurnished,
                        items: _isFurnishedOptions,
                        onChanged: (value) => setState(() => _isFurnished = value),
                      ),
                      DropdownFormField(
                        label: 'Parking Space',
                        value: _parkingSpace,
                        items: _parkingSpaceOptions,
                        onChanged: (value) => setState(() => _parkingSpace = value),
                      ),

                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _isFormValid() && !_isLoading ? _submitForm : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue[700],
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                            : const Text('Predict Rent', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (_predictedRent != null)
                PredictionResultCard(predictedRent: _predictedRent!),

              if (_errorMessage != null)
                ErrorMessageCard(errorMessage: _errorMessage!),
            ],
          ),
        ),
      ),
    );
  }
}
