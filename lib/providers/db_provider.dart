import 'package:rxdart/rxdart.dart';
import '../services/helper/db_helper.dart';
import '../models/image_model.dart';
import '../models/glitch.dart';
import 'data_source.dart';


class DbProvider implements DataSource {
	final DbHelper _db = DbHelper();
	final _localImages = PublishSubject<List<ImageModel>>();
	final _retrievedText = PublishSubject<String>();

	Stream<List<ImageModel>> get localImages => _localImages.stream;
	Stream<String> get retrievedText => _retrievedText.stream;

	clearCache() async {
		_db.clear();
		getLocalImages();
	}

	readImage(String imagePath) async {
		await _db.init();
		final image = await _db.fetchImage(imagePath);
		if (image != null) {
			_retrievedText.sink.add(image.retrievedtext);
		}
	}

	deleteImageFromCache(ImageModel image, {bool removeFile=true}) async {
		await _db.deleteImageRecordDb(image.imagePath, removeFile: removeFile);
		getLocalImages();
	}

	Future<void> getLocalImages() async {
		await _db.init();
		final images = await _db.fetchImages();
		if ( images != null && images != []) {
			_localImages.sink.add(images);
		} else {
			_localImages.sink.addError(EmptyCacheGlitch("Database is empty."));
		}
	}

	saveImage(ImageModel image) async {
		await _db.addImage(image);
		getLocalImages();
	}

	dispose() {
		_localImages.close();
		_retrievedText.close();
	}

}