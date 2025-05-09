
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
