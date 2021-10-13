import 'package:flutter/material.dart';


class EmptyDocument extends StatelessWidget {
	final ImageProvider _image = AssetImage('assets/ocr-image-1.jpeg');

	@override 
	Widget build(BuildContext context) {
		final double radius = MediaQuery.of(context).size.width/4;
		return Tooltip(
			preferBelow: true,
			verticalOffset: radius,
			message: "Reads text from image",
			child: CircleAvatar(
				radius: radius,
				backgroundColor: Colors.white,
				backgroundImage: _image,
			),
		);
	}
}