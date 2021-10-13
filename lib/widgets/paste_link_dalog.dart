import 'package:flutter/material.dart';


class LinkDialogBox extends StatefulWidget { 
	_LinkDialogBoxState createState() => _LinkDialogBoxState();
}

class _LinkDialogBoxState extends State<LinkDialogBox> {
	@override 
	Widget build(BuildContext context) {
		return AlertDialog(
			title: Text('Paste link here....'),
			content: Container(
				width: 50,
				height: 60,
				color: Colors.red,
			),
		);
	}
}