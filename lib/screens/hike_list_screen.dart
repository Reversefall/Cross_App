import 'package:flutter/material.dart';
import 'package:hike_app/database_helper.dart';
import 'package:hike_app/models/hike.dart';
import 'package:hike_app/screens/add_hike_screen.dart';
import 'package:hike_app/screens/edit_hike_screen.dart';

class HikeListScreen extends StatefulWidget {
  @override
  _HikeListScreenState createState() => _HikeListScreenState();
}

class _HikeListScreenState extends State<HikeListScreen> {
  List<Hike> hikes = [];

  @override
  void initState() {
    super.initState();
    _loadHikes();
  }

  _loadHikes() async {
    final List<Hike> loadedHikes = await DatabaseHelper.instance.getAllHikes();
    setState(() {
      hikes = loadedHikes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hike List')),
      body: ListView.builder(
        itemCount: hikes.length,
        itemBuilder: (context, index) {
          final hike = hikes[index];
          return ListTile(
            title: Text(hike.name),
            subtitle: Text('${hike.location} - ${hike.date}'),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditHikeScreen(hike: hike),
                ),
              );
              if (result != null) {
                _loadHikes(); 
              }
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper.instance.deleteHike(hike.id!);
                _loadHikes();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHikeScreen()),
          );
          if (result != null) {
            _loadHikes(); 
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
