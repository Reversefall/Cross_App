class Hike {
  int? id;
  String name;
  String location;
  String date;
  String parkingAvailable;
  double length;
  String difficulty;
  String description;
  String weatherConditions;  
  String safetyTips;  

  Hike({
    this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.parkingAvailable,
    required this.length,
    required this.difficulty,
    this.description = '',
    this.weatherConditions = '',
    this.safetyTips = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date,
      'parkingAvailable': parkingAvailable,
      'length': length,
      'difficulty': difficulty,
      'description': description,
      'weatherConditions': weatherConditions,
      'safetyTips': safetyTips,
    };
  }

  factory Hike.fromMap(Map<String, dynamic> map) {
    return Hike(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      date: map['date'],
      parkingAvailable: map['parkingAvailable'],
      length: map['length'],
      difficulty: map['difficulty'],
      description: map['description'],
      weatherConditions: map['weatherConditions'],
      safetyTips: map['safetyTips'],
    );
  }
}
