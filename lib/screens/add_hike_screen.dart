import 'package:flutter/material.dart';
import 'package:hike_app/database_helper.dart';
import 'package:hike_app/models/hike.dart';

class AddHikeScreen extends StatefulWidget {
  @override
  _AddHikeScreenState createState() => _AddHikeScreenState();
}

class _AddHikeScreenState extends State<AddHikeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _parkingController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _weatherConditionsController = TextEditingController();
  final TextEditingController _safetyTipsController = TextEditingController();

  String? _selectedDifficulty;

  final List<String> _difficultyItems = ["Easy", "Medium", "Hard"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Hike')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, "Name", true),
              _buildTextField(_locationController, "Location", true),
              _buildTextField(_dateController, "Date", true),
              _buildTextField(_parkingController, "Parking Available", true),
              _buildTextField(_lengthController, "Length (km)", true, number: true),

              SizedBox(height: 15),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Difficulty",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                value: _selectedDifficulty,
                items: _difficultyItems.map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: Text(d),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedDifficulty = value);
                },
                validator: (value) => value == null ? "Please select difficulty" : null,
              ),

              SizedBox(height: 15),

              _buildTextField(_descriptionController, "Description", false, maxLines: 3),
              _buildTextField(_weatherConditionsController, "Weather Conditions", false),
              _buildTextField(_safetyTipsController, "Safety Tips", false),

              SizedBox(height: 25),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final hike = Hike(
                      name: _nameController.text,
                      location: _locationController.text,
                      date: _dateController.text,
                      parkingAvailable: _parkingController.text,
                      length: double.parse(_lengthController.text),
                      difficulty: _selectedDifficulty!,
                      description: _descriptionController.text,
                      weatherConditions: _weatherConditionsController.text,
                      safetyTips: _safetyTipsController.text,
                    );

                    DatabaseHelper.instance.addHike(hike);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Added successfully!"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Navigator.pop(context, true);
                  }
                },
                child: Text('Add Hike'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      bool required, {
        bool number = false,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: required
            ? (value) => value!.isEmpty ? "Please enter $label" : null
            : null,
      ),
    );
  }
}
