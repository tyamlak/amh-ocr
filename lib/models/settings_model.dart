import 'package:flutter/material.dart' show MaterialColor, Colors;

class SettingsModel {
	bool autoSave;
	bool darkMode;
	MaterialColor appThemeColor;
	SettingsModel()
	  : autoSave = false,
	    darkMode = false,
	    appThemeColor = Colors.blue;

	setThemeColor(int colorNumber) {
		for (var c in Colors.primaries) {
			if (c.value == colorNumber) {
				appThemeColor = c;
			}
		}
	}
}