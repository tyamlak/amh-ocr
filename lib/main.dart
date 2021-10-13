import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'views/home_page.dart';
import 'views/view_image.dart';
import 'views/settings.dart';
import 'providers/settings_provider.dart';
import 'getit.dart';

void main(){
  setUp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _settingsProvider = getIt<SettingsProvider>();

  MyApp() {
    _settingsProvider.initialize().then((int n){
      if (n == 0) {
        _settingsProvider.loadSettings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _settingsProvider.themeSettings,
      builder: (BuildContext context, AsyncSnapshot<SettingsModel> snapshot) {
        final settings = snapshot.data ?? _settingsProvider.settingsData;
        return MaterialApp(
          title: 'Amharic OCR',
          theme: ThemeData(
            primarySwatch:  settings.appThemeColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: settings.darkMode ? Brightness.dark : Brightness.light,
            appBarTheme: AppBarTheme(
              color: settings.appThemeColor.shade900,
            ),
            iconTheme: IconThemeData(
              color: settings.appThemeColor.shade700,
            ),
          ),
          onGenerateRoute: routes,
        );
      }
    );
  }

  // ignore: missing_return
  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return CupertinoPageRoute(
        builder: (BuildContext context) {
          return HomePage(title: "Amharic OCR",);
        }
      );
    } else if (settings.name == 'viewTextImage') {
        final String imagePath = settings.arguments as String;
		    return CupertinoPageRoute(
			    builder: (BuildContext context) {
				    return ViewTextFromImage(imagePath);
			    }
		    );
	  } else if (settings.name == 'viewTextImageFromCache') {
		    final String imagePath = settings.arguments as String;
		    return CupertinoPageRoute(
			    builder: (BuildContext context) {
				    return ViewTextFromImage(imagePath, source: "db",);
			    }
		    );
	  } else if (settings.name == 'appSettings') {
		  return CupertinoPageRoute(
			  builder: (BuildContext context) {
				  return AppSettings();
			  }
		  );
	  }
  }
}