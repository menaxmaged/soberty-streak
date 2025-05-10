import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:home_widget/home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int streakDays = 0;
  String appGroupId = "group.net.codexeg.sobertyStreak";
  String iosWidgetName = "StreakWidget";
  String dataKey = "streak";

  Future<void> pushEventsToWidget() async {
    try {
      // Your predefined list of events
      List<Map<String, dynamic>> events = [
        {"name": "End of an Era", "dateString": "2023-03-14"},
        {"name": "No Contact", "date": "2023-03-16"},
        {"name": "Sobriety Journey", "date": "2023-05-14"},
        {"name": "nn", "date": "2025-03-01"},
      ];

      // Convert the events list to JSON string
      String eventsJson = jsonEncode(events);
      print(eventsJson);
      // Save the JSON string to the widget using HomeWidget
      await HomeWidget.saveWidgetData('event_data', eventsJson);

      // Update the widget immediately (optional)
      await HomeWidget.updateWidget(
        name: 'StreakWidget', // Your widget name
        iOSName: 'StreakWidget', // Your widget's iOS name
      );

      print("Events pushed to Widget successfully.");
    } catch (e) {
      print("Failed to push events to Widget: $e");
    }
  }

  void incrementStreak() async {
    setState(() {
      streakDays++;
    });

    await HomeWidget.saveWidgetData(dataKey, streakDays);
    await HomeWidget.updateWidget(
      iOSName: iosWidgetName,
      androidName: iosWidgetName,
    );
  }

  void changeName() async {
    await HomeWidget.saveWidgetData("username", 'Menaaaaa');
    await HomeWidget.updateWidget(
      iOSName: iosWidgetName,
      androidName: iosWidgetName,
    );
  }

  void resetStreak() async {
    setState(() {
      streakDays = 0;
    });
    await HomeWidget.saveWidgetData(dataKey, 0);
    await HomeWidget.updateWidget(
      iOSName: iosWidgetName,
      androidName: iosWidgetName,
    );
  }

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId(appGroupId);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar.large(
        largeTitle: Text("Soberty Streak"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Your Soberty Streak:', style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                Text(
                  '$streakDays Days',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                CupertinoButton(
                  onPressed: incrementStreak,
                  child: Text('Increment Streak'),
                ),
                CupertinoButton(
                  onPressed: changeName,
                  child: Text('Change Name'),
                ),

                CupertinoButton(
                  onPressed: pushEventsToWidget, // ✅ Fixed: Correct syntax
                  child: Text('Push Events to Widget'), // ✅ Updated label
                ),
                CupertinoButton.tinted(
                  onPressed: resetStreak,
                  child: Text('Reset Streak'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
