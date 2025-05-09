import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int streakDays = 0;

  void incrementStreak() {
    setState(() {
      streakDays++;
    });
  }

  void resetStreak() {
    setState(() {
      streakDays = 0;
    });
  }

  @override
  void initState() {
    super.initState();
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
    );
  }
}
