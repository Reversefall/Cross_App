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
  late TextEditingController _difficultyController;
  late TextEditingController _descriptionController;
  late TextEditingController _weatherConditionsController;
  late TextEditingController _safetyTipsController;

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
    _difficultyController = TextEditingController(text: widget.hike.difficulty);
    _descriptionController = TextEditingController(
      text: widget.hike.description,
    );
    _weatherConditionsController = TextEditingController(
      text: widget.hike.weatherConditions,
    );
    _safetyTipsController = TextEditingController(text: widget.hike.safetyTips);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _parkingController.dispose();
    _lengthController.dispose();
    _difficultyController.dispose();
    _descriptionController.dispose();
    _weatherConditionsController.dispose();
    _safetyTipsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Hike')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a location' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a date' : null,
              ),
              TextFormField(
                controller: _parkingController,
                decoration: InputDecoration(labelText: 'Parking Available'),
                validator: (value) =>
                    value!.isEmpty ? 'Please specify parking' : null,
              ),
              TextFormField(
                controller: _lengthController,
                decoration: InputDecoration(labelText: 'Length'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the length' : null,
              ),
              TextFormField(
                controller: _difficultyController,
                decoration: InputDecoration(labelText: 'Difficulty'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter difficulty level' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _weatherConditionsController,
                decoration: InputDecoration(labelText: 'Weather Conditions'),
              ),
              TextFormField(
                controller: _safetyTipsController,
                decoration: InputDecoration(labelText: 'Safety Tips'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedHike = Hike(
                      id: widget.hike.id, 
                      name: _nameController.text,
                      location: _locationController.text,
                      date: _dateController.text,
                      parkingAvailable: _parkingController.text,
                      length: double.parse(_lengthController.text),
                      difficulty: _difficultyController.text,
                      description: _descriptionController.text,
                      weatherConditions: _weatherConditionsController.text,
                      safetyTips: _safetyTipsController.text,
                    );

                    DatabaseHelper.instance.updateHike(updatedHike);
                    Navigator.pop(
                      context,
                      true,
                    );
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
}
