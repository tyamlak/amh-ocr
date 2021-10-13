import 'dart:io' as io;
import '../image_db.dart';
import '../../models/image_model.dart';


class DbHelper {
	final _db = ImageDb();

	init() async {
		await _db.init();
	}

	bool isImageAvailable(String imagePath, {bool deleteRecord=true}) {
		if (!io.File(imagePath).existsSync()) {
			if (deleteRecord) {
				print('Image $imagePath not found in the filesystem...deleting it.');
				deleteImageRecordDb(imagePath);
			}
			return false;
		}
		return true;
	}

	Future<int> clear() async {
		final imageList = await fetchImages();
		int rowsAffected = await _db.clear();
		if ( rowsAffected <= 0 ) return null;
		for (var image in imageList) {
			_removeImageFileFromCache(image.imagePath);
		}
		return _db.clear();
	}

	_removeImageFileFromCache(String path) {
		if (io.File(path).existsSync()) {
			io.File(path).deleteSync();
		}
	}

	Future<int> addImage(ImageModel image) {
		return _db.addImage(image.toMap());
	}

	Future<int> deleteImageRecordDb(String imagePath, {bool removeFile=true}) async {
		return _db.deleteImageFromDb(imagePath)..then((_) {
			if (removeFile) _removeImageFileFromCache(imagePath);
		});
	}

	Future<ImageModel> fetchImage(String imagePath) async {
		final result = await _db.fetchImage(imagePath);
		if (result != null && isImageAvailable(imagePath)) {
			return ImageModel.fromDb(result);
		}
		return null;
	}

	Future<List<ImageModel>> fetchImages() async {
		List<ImageModel> images = [];
		for (var x in await _db.fetchImages()) {
			final imageModel = ImageModel.fromDb(x);
			if (isImageAvailable(imageModel.imagePath)) {
				images.add(imageModel);
			}
		}
		if (images.length > 0) {
			return images;
		}
		return null;
	}

}