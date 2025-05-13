import '/core/utils/helper.dart';

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
    final eventsJson = await HomeWidget.getWidgetData<String>(eventsDataKey);
    if (eventsJson != null) {
      setState(() {
        eventsList = List<Map<String, dynamic>>.from(jsonDecode(eventsJson));
      });
    }
  }

  /// Add Event Manually
  void addEvent(event) {
    try {
      DateTime eventDate = dateFormat.parse(event.date);
      String formattedDate = dateFormat.format(eventDate);

      final newEvent = {'name': event.name, 'dateString': formattedDate};
      setState(() {
        //        eventsList.add(newEvent);
      });
      //      pushEventsToWidget();
    } catch (e) {
      print("Error: Invalid date format.");
    }
  }

  /// Push Events Data to Widget
  Future<void> pushEventsToWidget() async {
    try {
      String eventsJson = jsonEncode(eventsList);
      await HomeWidget.saveWidgetData(eventsDataKey, eventsJson);
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
    await HomeWidget.saveWidgetData(eventsDataKey, jsonEncode([]));
    await HomeWidget.updateWidget(name: iosWidgetName, iOSName: iosWidgetName);
    print("Events reset successfully.");
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
                  pushEventsToWidget();
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
                                  pushEventsToWidget();
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
            ],
          ),
        ),
      ),
    );
  }
}
