import 'package:get_it/get_it.dart';
import './providers/api_provider.dart';
import './providers/db_provider.dart';
import './providers/settings_provider.dart';


final getIt = GetIt.instance;

void setUp() {
	getIt.registerSingleton<ApiProvider>(ApiProvider());
	getIt.registerSingleton<DbProvider>(DbProvider());
	getIt.registerSingleton<SettingsProvider>(SettingsProvider());
}