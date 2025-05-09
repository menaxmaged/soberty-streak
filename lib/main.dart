import 'core/utils/helper.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';

//test
//const force_cupertino = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async before runApp

  //  await CacheHelper.init();

  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(title: appName, home: SplashScreen());
  }
}
