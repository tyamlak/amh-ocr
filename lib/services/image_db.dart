import 'dart:io';
import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class ImageDb {
	Database db;
	ImageDb() {
		init();
	}

	init() async {
		WidgetsFlutterBinding.ensureInitialized();
		Directory documentsDirectory = await getApplicationDocumentsDirectory();
		final path = join(documentsDirectory.path, "images.db");
		db = await openDatabase(
			path,
			version: 1,
			onCreate: (Database newDb, int version) {
				newDb.execute(
					"""
					CREATE TABLE Images(
						imagePath TEXT PRIMARY KEY,
						retrievedText TEXT
					)
					"""
				);
			}
		);
	}

	Future<int> clear() async{
		return db.delete(
			"Images",		
		);
	}

	Future<int> addImage(Map<String, dynamic> values) {
		return db.insert(
			"Images",
			values,
			conflictAlgorithm: ConflictAlgorithm.ignore,
		);
	}

	Future<int> deleteImageFromDb(String imagePath) async {
		return db.delete(
			"Images", 
			where: "imagePath = ?",
			whereArgs: [imagePath],
		);
	}

	Future<Map<String, dynamic>> fetchImage(String imagePath) async {
		final result = await db.query(
			"Images",
			where: "imagePath = ?",
			whereArgs: [imagePath],
		);
		return result.length>0 ? result.first: null;
	}

	Future<List<Map<String, dynamic>>> fetchImages() async {
		final result = await db.query(
			'Images',
			columns: null,
		);
		return result;
	}
}