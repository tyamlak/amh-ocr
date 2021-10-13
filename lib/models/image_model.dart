class ImageModel {
	final String imagePath;
	final String retrievedtext;

	ImageModel({this.imagePath, this.retrievedtext});

	ImageModel.fromDb(Map<String, dynamic> item)
		: imagePath = item['imagePath'],
		  retrievedtext = item['retrievedText'] ?? "";

	Map<String, dynamic> toMap() {
		return {
			'imagePath': imagePath,
			'retrievedText': retrievedtext ?? "",
		};
	}
}