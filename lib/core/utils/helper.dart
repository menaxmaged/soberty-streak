// all_exports.dart
// imports
// import '/core/utils/cache-helper.dart';

import 'dart:ffi';

import 'package:flutter/cupertino.dart';

export 'functions.dart';
export 'constants.dart';
export 'cache-helper.dart';
export 'package:flutter/cupertino.dart';

export '/Layout.dart';
//export 'firebase_auth.dart';
// export 'api-handler.dart';
export 'dart:convert';
export '/core/pages/pages.dart';
export 'dart:developer' hide Flow;
export 'package:home_widget/home_widget.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:flutter/material.dart' hide RefreshCallback;

String isDarkModekey = 'isDarkMode';
// bool? isDarkMode = CacheHelper.getData(isDarkModekey);
String isLoggedInkey = 'isLoggedIn';
// bool isLoggedIn = CacheHelper.getData(isLoggedInkey) ?? false;

//bool isLoggedIn = true;

List<Map<String, dynamic>> eventsList = [];

class Event {
  String name;
  String dateString;
  int color;

  Event({required this.name, required this.dateString, required this.color});

  // Convert Event to a Map for serialization
  Map<String, dynamic> toJson() {
    return {'name': name, 'dateString': dateString, 'color': color};
  }

  // Create an Event from a Map
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      dateString: json['dateString'],
      color: json['color'],
    );
  }
}
