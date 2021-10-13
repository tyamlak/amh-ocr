import 'package:Amharic_OCR/widgets/color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';
import '../getit.dart' show getIt;


class AppSettings extends StatefulWidget {
	createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
	final _settingsProvider = getIt<SettingsProvider>();
	
	@override 
	void initState() {
		_settingsProvider.initialize().then((int n) {
			if (n == 0 ) {
				_settingsProvider.loadSettings();
			}
		});
		super.initState();
	}

	@override 
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Settings'),
			),
			body: Container(
				padding: EdgeInsets.all(10),
				child: StreamBuilder(
					stream: _settingsProvider.settings,
     				// ignore: missing_return
					builder: (BuildContext context, AsyncSnapshot<SettingsModel> snapshot) {
						if (snapshot.connectionState == ConnectionState.waiting){
							return Center(child: CircularProgressIndicator(),);
						} else if (snapshot.hasData) {
							final settings = snapshot.data;
							return Column(
								children: [
									ListTile(
										leading: Text(
											'Auto-Save Document', 
											style: TextStyle(
												fontWeight: FontWeight.bold,
												fontSize: 16,
											),
										),
										trailing: Switch(
											value: settings.autoSave ?? false,
											onChanged: (bool _ ) {
												_settingsProvider.toggleAutoSave();
											},
										),
										onTap: () {
											_settingsProvider.toggleAutoSave();
										},
									),
									ListTile(
										leading: Text(
											'Theme Color', 
											style: TextStyle(
												fontWeight: FontWeight.bold,
												fontSize: 16,
											),
										),
										trailing: Container(
											width: 30,
											height: 30,
											margin: EdgeInsets.only(right: 12),
											decoration: BoxDecoration(
												color: _settingsProvider.settingsData.appThemeColor.shade500,
												shape: BoxShape.circle,
											),
										),
										onTap: () {
											showDialog(
												context: context,
												child: ColorPicker(
													Colors.primaries,
													_settingsProvider.changeThemeColor,
													selectedColor: _settingsProvider.settingsData.appThemeColor,
												),
											);
										},
									),
									ListTile(
										leading: Text(
											'Dark Mode', 
											style: TextStyle(
												fontWeight: FontWeight.bold,
												fontSize: 16,
											),
										),
										trailing: Switch(
											value: settings.darkMode ?? false,
											onChanged: (bool _ ) {
												_settingsProvider.toggleDarkMode();
											},
										),
										onTap: () {
											_settingsProvider.toggleDarkMode();
										},
									),
								],
							);						
						} else if (snapshot.hasError) {
							return Center(child: Text('No Settings Found.'));
						}
					},
				),
			),
		);
	}
}