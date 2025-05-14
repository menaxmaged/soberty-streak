import '/core/utils/helper.dart';
import 'package:cloud_kit/cloud_kit.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
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
    super.dispose();
  }

  /// Load Events from Widget Data
  Future<void> loadEvents() async {
    // Check iCloud account status
    CloudKitAccountStatus accountStatus = await cloudKit.getAccountStatus();

    // Try to get data from the widget
    final String? eventsJson = await HomeWidget.getWidgetData<String>(
      eventsDataKey,
    );

    // If widget data is unavailable, fetch from iCloud
    final String dataToUse = eventsJson ?? await cloudKit.get('events') ?? '';

    // Check if data is available
    if (dataToUse.isNotEmpty) {
      // Set the state to update the UI
      setState(() {
        // Update the widget with the loaded events data
        pushEventsToWidget(dataToUse);

        // Parse the JSON data into a list of events
        try {
          eventsList = List<Map<String, dynamic>>.from(jsonDecode(dataToUse));
        } catch (e) {
          // Handle JSON decoding errors
          print("Error decoding events data: $e");
        }
      });
    } else {
      print("No events data found.");
    }
  }

  Future<void> saveEvents() async {
    String eventsJson = jsonEncode(eventsList);

    try {
      await pushEventsToWidget(eventsJson);

      CloudKitAccountStatus accountStatus = await cloudKit.getAccountStatus();
      if (accountStatus == CloudKitAccountStatus.available) {
        print("logged IN");
        print("Pushing");

        print(
          await cloudKit.save('events', eventsJson),
        ); // both must be strings, if you want to save objects use the JSON format

        // User is logged in to iCloud, you can start using the plugin
      }
    } catch (e) {
      if (e is PlatformException && e.code == 'Error') {
        // Handle the case where the key already exists
        print("Record already exists in the database");
        print(await deleteEvents());
        print(await cloudKit.save('events', eventsJson));
        // You could perform an update or notify the user, etc.
      }

      print("Error pushing events to Icloud: $e");
    }
  }

  Future<bool> deleteEvents() async {
    print("deleting");
    return await cloudKit.delete(
      'events',
    ); // returns a boolean if it was successful
  }

  /// Push Events Data to Widget
  Future<void> pushEventsToWidget(String events) async {
    try {
      await HomeWidget.saveWidgetData(eventsDataKey, events);
      await HomeWidget.updateWidget(
        name: iosWidgetName,
        iOSName: iosWidgetName,
        androidName: iosWidgetName,
      );
      // Optionally show a success snackbar or feedback message
    } catch (e) {
      print("Error pushing events to Widget: $e");
    }
  }

  /// Reset Events Data
  Future<void> resetEvents() async {
    setState(() {
      eventsList.clear();
    });
    await deleteEvents();
    await HomeWidget.saveWidgetData(eventsDataKey, jsonEncode([]));
    await HomeWidget.updateWidget(name: iosWidgetName, iOSName: iosWidgetName);
    print("Events reset successfully.");
  }

  void getter() async {
    print("zzz");
    CloudKitAccountStatus accountStatus = await cloudKit.getAccountStatus();
    if (accountStatus == CloudKitAccountStatus.available) {
      print("logged IN");
      print(accountStatus);
      print(await cloudKit.get('events'));
      // User is logged in to iCloud, you can start using the plugin
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  // Show Add Event
  void _showAddEvent() {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
            child: SafeArea(
              child: AddEventModal(
                onEventAdded: (context) {
                  print(context);
                  setState(() {
                    eventsList.add(context);
                  });
                  saveEvents();
                  print("object");
                },
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        largeTitle: Text("Soberty Events"),
        trailing: IconButton(
          onPressed: () {
            _showAddEvent();
          },
          icon: Icon(CupertinoIcons.add_circled),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              Expanded(
                child:
                    eventsList.isEmpty
                        ? Center(child: Text("No events added"))
                        : ListView.builder(
                          itemCount: eventsList.length,
                          itemBuilder: (context, index) {
                            final event = eventsList[index];
                            return CupertinoListTile(
                              title: Text(event['name']),
                              subtitle: Text(event['dateString'].toString()),
                              trailing: CupertinoButton(
                                child: Icon(
                                  CupertinoIcons.delete,
                                  color: CupertinoColors.destructiveRed,
                                ),
                                onPressed: () {
                                  setState(() {
                                    eventsList.removeAt(index);
                                  });
                                  saveEvents();
                                },
                              ),
                            );
                          },
                        ),
              ),

              SizedBox(height: 20),
              CupertinoButton(
                onPressed: resetEvents,
                child: Text('Reset Events'),
              ),
              SizedBox(height: 20),
              CupertinoButton(onPressed: getter, child: Text('Get Events')),
            ],
          ),
        ),
      ),
    );
  }
}
