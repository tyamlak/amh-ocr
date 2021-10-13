import 'package:rxdart/rxdart.dart';
import '../services/helper/api_helper.dart';
import '../models/glitch.dart';
import 'data_source.dart';

class ApiProvider implements DataSource {
	final _api = ApiHelper();
	final _retrievedText = PublishSubject<String>();

	Stream<String> get retrievedText => _retrievedText.stream;
	
	readImage(String imagePath) async {
		final result = await _api.postImage(imagePath);
		result.fold(
			(Glitch error) {
				_retrievedText.addError(error);
			}, (String text) {
				_retrievedText.add(text);
			}
		);
	}

	dispose() {
		_retrievedText.close();
	}
}