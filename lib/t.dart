import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<List<Map<String, dynamic>>> getEvents() async {
    const platform = MethodChannel('com.yourapp.events');
    final String? jsonString = await platform.invokeMethod('getEvents');
    if (jsonString == null) {
      return [];
    }

    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Sobriety Events')),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: getEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Events Found'));
            } else {
              return ListView(
                children:
                    snapshot.data!.map((event) {
                      return ListTile(
                        title: Text(event['name']),
                        subtitle: Text(event['date']),
                      );
                    }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
