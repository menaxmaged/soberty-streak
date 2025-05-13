import 'helper.dart';

const String appName = "Soberty Streak";
final String appVersion = "1.0.0";
final String appDescription =
    "Efhmni is a language learning app that helps you learn Arabic through fun and interactive methods.";

const String appAuthor = "Mena Maged";
const primary_color = Color(0xFF7E4AEF);

String appGroupId = "group.net.codexeg.sobertystreaker";
String iosWidgetName = "StreakWidget";
String eventsDataKey = "events_data";
final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

const default_username = "mena";
const default_password = "allow2me";

CupertinoThemeData mytheme(BuildContext context) {
  Brightness? brightness;
  if ("isDarkMode" == null) {
    brightness = MediaQuery.of(context).platformBrightness;
  } else {
    brightness =
        "isDarkMode" == true
            ? Brightness.dark
            : Brightness.light; // Get the current brightness of the device
  }
  log(
    "Brightness: $brightness",
    name: 'ThemeLogger',
  ); // Log the current brightness for debugging
  // Get the current brightness of the device

  return CupertinoThemeData(
    primaryColor: primary_color, // Set the primary color for the theme
    brightness:
        brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light, // Set the brightness based on the system theme
  );
}
