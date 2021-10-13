import 'dart:io' as io;
import 'package:flutter/material.dart';
import '../providers/db_provider.dart';
import '../models/image_model.dart';
import '../getit.dart' show getIt;

class ImageTile extends StatelessWidget {
	final ImageModel image;
	final _dbProvider = getIt<DbProvider>();

	ImageTile(this.image);

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				InkWell(
					splashColor: Colors.black26,
					child: Container (
						width: MediaQuery.of(context).size.width,
						height: 115,
						padding: EdgeInsets.all(5),
						margin: EdgeInsets.all(5),
						child: SingleChildScrollView(
							scrollDirection: Axis.horizontal,
							child: Row(
								children: [
									Container(
										width: 120,
										height: 120,
										child: ClipRRect(
											borderRadius: BorderRadius.circular(5),
											child: Image(image:FileImage(io.File(image.imagePath))),
										),
									),
									VerticalDivider(color: Colors.black,),
									Text(
										"${image.retrievedtext.substring(0, image.retrievedtext.length <= 13 ? null : 13 )}...",
										style: TextStyle(
											fontWeight: FontWeight.bold,
										),
									),
									Padding(
										padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
										child: IconButton(
											icon: Icon(Icons.delete, size: 30, color: Colors.red),
											onPressed: () {
												_dbProvider.deleteImageFromCache(image);
											},
										),
									),
								],
							),
						),
					),
					onTap: () {
						Navigator.pushNamed(context, 'viewTextImageFromCache', arguments: image.imagePath);
					},
				),
				Divider(color: Colors.black54),
			],
		);
	}
}