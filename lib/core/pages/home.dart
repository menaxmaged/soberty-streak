import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String appGroupId = "group.net.codexeg.sobertyStreak";
  String iosWidgetName = "StreakWidget";
  String eventsDataKey = "events_data";
  List<Map<String, dynamic>> eventsList = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId(appGroupId);
    WidgetsBinding.instance.addObserver(this);
    loadEvents();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    nameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  /// Load Events from Widget Data
  Future<void> loadEvents() async {
    final eventsJson = await HomeWidget.getWidgetData<String>(eventsDataKey);
    if (eventsJson != null) {
      setState(() {
        try {
          eventsList = List<Map<String, dynamic>>.from(jsonDecode(eventsJson));
        } catch (e) {
          print("Error decoding events JSON: $e");
          eventsList = [];
        }
      });
    }
  }

  /// Add Event Manually
  void addEvent() {
    if (nameController.text.trim().isEmpty) {
      print("Event name cannot be empty.");
      return;
    }

    try {
      // Validate and format the date
      DateTime eventDate = dateFormat.parse(dateController.text.trim());
      String formattedDate = dateFormat.format(eventDate);

      final newEvent = {
        "name": nameController.text.trim(),
        "dateString": formattedDate,
      };

      setState(() {
        eventsList.add(newEvent);
      });

      print("Event added: $newEvent");
      pushEventsToWidget();
      nameController.clear();
      dateController.clear();
    } catch (e) {
      print("Invalid date format. Please use YYYY-MM-DD.");
    }
  }

  /// Push Events Data to Widget
  Future<void> pushEventsToWidget() async {
    try {
      String eventsJson = jsonEncode(eventsList);
      print("Events JSON: $eventsJson");

      await HomeWidget.saveWidgetData(eventsDataKey, eventsJson);

      await HomeWidget.updateWidget(
        name: iosWidgetName,
        iOSName: iosWidgetName,
      );

      print("Events pushed to Widget successfully.");
    } catch (e) {
      print("Error pushing events to Widget: $e");
    }
  }

  /// Reset Events Data
  Future<void> resetEvents() async {
    setState(() {
      eventsList.clear();
    });

    await HomeWidget.saveWidgetData(eventsDataKey, jsonEncode([]));
    await HomeWidget.updateWidget(name: iosWidgetName, iOSName: iosWidgetName);
    print("Events reset successfully.");
  }

  /// Delete a Specific Event
  void deleteEvent(int index) {
    setState(() {
      eventsList.removeAt(index);
    });
    pushEventsToWidget();
    print("Event deleted at index $index");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Soberty Events"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Manage Your Soberty Events:',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              CupertinoTextField(
                controller: nameController,
                placeholder: "Event Name",
              ),
              SizedBox(height: 10),
              CupertinoTextField(
                controller: dateController,
                placeholder: "Event Date (YYYY-MM-DD)",
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 10),
              CupertinoButton.filled(
                onPressed: addEvent,
                child: Text('Add Event'),
              ),
              SizedBox(height: 20),
              CupertinoButton.filled(
                onPressed: pushEventsToWidget,
                child: Text('Push Events to Widget'),
              ),
              CupertinoButton(
                onPressed: resetEvents,
                child: Text('Reset Events'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: eventsList.length,
                  itemBuilder: (context, index) {
                    final event = eventsList[index];
                    return CupertinoListTile(
                      title: Text(event['name']),
                      subtitle: Text(event['dateString']),
                      trailing: CupertinoButton(
                        child: Icon(
                          CupertinoIcons.delete,
                          color: CupertinoColors.destructiveRed,
                        ),
                        onPressed: () => deleteEvent(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
