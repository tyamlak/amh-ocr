import 'package:flutter/material.dart' show Color;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings_model.dart';
export '../models/settings_model.dart';


class SettingsProvider {
	SharedPreferences pref;
	final SettingsModel _settingsData = SettingsModel();
	final _settings = PublishSubject<SettingsModel>();
	final _themeSettings = PublishSubject<SettingsModel>();

	Stream<SettingsModel> get settings => _settings.stream;
	Stream<SettingsModel> get themeSettings => _themeSettings.stream;
	SettingsModel get settingsData => _settingsData;

	Future<int> initialize() async {
		try {
			pref = await SharedPreferences.getInstance();
		} catch(e) {
			print('Error getting SharedPreferences instance: $e');
			return 1;
		}
		return 0;
	}

	loadSettings() {
		_settingsData.autoSave = pref.getBool('autosave')?? false;
		int colorNumber = pref.getInt('appThemeColor');
		if (colorNumber != null ) {
			_settingsData.setThemeColor(colorNumber);
		}
		_settingsData.darkMode = pref.getBool('darkMode')?? false;
		updateThemeSettings();
		updateSettings();
	}

	updateSettings () {
		_settings.sink.add(_settingsData);
	}

	updateThemeSettings() {
		_themeSettings.sink.add(_settingsData);
	}

	toggleAutoSave() {
		_settingsData.autoSave = ! _settingsData.autoSave;
		pref.setBool('autosave', _settingsData.autoSave);
		updateSettings();
	}

	toggleDarkMode() {
		_settingsData.darkMode = ! _settingsData.darkMode;
		pref.setBool('darkMode', _settingsData.darkMode);
		updateThemeSettings();
	}

	changeThemeColor(Color color) {
		_settingsData.appThemeColor = color;
		pref.setInt('appThemeColor', color.value);
		updateThemeSettings();
	}

	dispose() {
		_settings.close();
		_themeSettings.close();
	}
}