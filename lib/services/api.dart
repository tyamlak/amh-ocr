import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';


final String baseUrl = "https://amh-tesseract-api.herokuapp.com/upload";

class API {
	
	Future<Either<Exception, http.StreamedResponse>> postImage(String imagePath) async {
		var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
		request.files.add(await http.MultipartFile.fromPath('image', imagePath));
		try{
			final response = await request.send().timeout(Duration(seconds:120));
			return Right(response);
		} catch(e) {
			return Left(e);
		}
	}
}