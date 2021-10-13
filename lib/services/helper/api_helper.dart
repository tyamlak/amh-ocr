import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../api.dart';
import '../../models/glitch.dart';


class ApiHelper {
	final _api = API();

	Future<Either<Glitch, String>> postImage(String imagePath) async  {
		String text;
		final result = await _api.postImage(imagePath);
		return result.fold((exc){
			if (exc is HttpException) {
				return Left(Glitch('Connection error.'));
			} else if (exc is TimeoutException) {
				return Left(Glitch('Connection error.'));
			} else if (exc is SocketException) {
				return Left(Glitch('Check your internet.'));
			} else {
				return Left(Glitch('unknow error: try later.'));
			}
		}, (response) async {
			if (response.statusCode == 200) {
				text = await response.stream.bytesToString();
				return Right(text);
			} else if( response.statusCode == 503) {
				return Left(Glitch( response.reasonPhrase != null ? response.reasonPhrase : 'Server busy.'));
			} else {
				print('Error: http Status code ${response.statusCode} was returned.');
				return Left(Glitch('Server error.'));

			}
		});
	}
}