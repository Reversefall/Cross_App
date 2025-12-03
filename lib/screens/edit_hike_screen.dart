import 'package:flutter/material.dart';
import 'package:hike_app/database_helper.dart';
import 'package:hike_app/models/hike.dart';

class EditHikeScreen extends StatefulWidget {
  final Hike hike;

  EditHikeScreen({required this.hike});

  @override
  _EditHikeScreenState createState() => _EditHikeScreenState();
}

class _EditHikeScreenState extends State<EditHikeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _parkingController;
  late TextEditingController _lengthController;
  late TextEditingController _descriptionController;
  late TextEditingController _weatherConditionsController;
  late TextEditingController _safetyTipsController;

  String? _selectedDifficulty;
  final List<String> _difficultyItems = ["Easy", "Medium", "Hard"];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.hike.name);
    _locationController = TextEditingController(text: widget.hike.location);
    _dateController = TextEditingController(text: widget.hike.date);
    _parkingController = TextEditingController(
      text: widget.hike.parkingAvailable,
    );
    _lengthController = TextEditingController(
      text: widget.hike.length.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.hike.description,
    );
    _weatherConditionsController = TextEditingController(
      text: widget.hike.weatherConditions,
    );
    _safetyTipsController = TextEditingController(text: widget.hike.safetyTips);

    _selectedDifficulty = widget.hike.difficulty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Hike')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, "Name", true),
              _buildTextField(_locationController, "Location", true),
              _buildTextField(_dateController, "Date", true),
              _buildTextField(_parkingController, "Parking Available", true),
              _buildTextField(
                _lengthController,
                "Length (km)",
                true,
                number: true,
              ),

              SizedBox(height: 15),

              // --- Dropdown Difficulty ---
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Difficulty",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: _selectedDifficulty,
                items: _difficultyItems.map((d) {
                  return DropdownMenuItem(value: d, child: Text(d));
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedDifficulty = value),
                validator: (value) =>
                    value == null ? "Please select difficulty" : null,
              ),

              SizedBox(height: 15),

              _buildTextField(
                _descriptionController,
                "Description",
                false,
                maxLines: 3,
              ),
              _buildTextField(
                _weatherConditionsController,
                "Weather Conditions",
                false,
              ),
              _buildTextField(_safetyTipsController, "Safety Tips", false),

              SizedBox(height: 25),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(
                          "Confirm Update",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text("Do you want to update the changes?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text("Update"),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    final updatedHike = Hike(
                      id: widget.hike.id,
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

                    await DatabaseHelper.instance.updateHike(updatedHike);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Updated successfully!"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );

                    Navigator.pop(context, true);
                  }
                },
                child: Text('Save Changes'),
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
