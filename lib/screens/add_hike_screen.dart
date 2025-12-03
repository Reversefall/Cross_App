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
  final TextEditingController _difficultyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _weatherConditionsController = TextEditingController();
  final TextEditingController _safetyTipsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Hike')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) => value!.isEmpty ? 'Please enter a date' : null,
              ),
              TextFormField(
                controller: _parkingController,
                decoration: InputDecoration(labelText: 'Parking Available'),
                validator: (value) => value!.isEmpty ? 'Please specify parking' : null,
              ),
              TextFormField(
                controller: _lengthController,
                decoration: InputDecoration(labelText: 'Length'),
                validator: (value) => value!.isEmpty ? 'Please enter the length' : null,
              ),
              TextFormField(
                controller: _difficultyController,
                decoration: InputDecoration(labelText: 'Difficulty'),
                validator: (value) => value!.isEmpty ? 'Please enter difficulty level' : null,
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
                    final hike = Hike(
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
                    DatabaseHelper.instance.addHike(hike);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Add successfully!"),
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
}
