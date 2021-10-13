import 'package:flutter/material.dart';

class SelectTranslationLanguage extends StatefulWidget {
	createState() => _SelectTranslationLanguageState();
}

class _SelectTranslationLanguageState extends State<SelectTranslationLanguage> {

	@override 
	Widget build(BuildContext context) {
		return AlertDialog(
			title: Text('Choose Language'),
			content: Container(
				height: MediaQuery.of(context).size.height*0.18,
				child: Column(
					children: [
						buildLanguageTile(Icon(Icons.sort_by_alpha), 'English'),
						Divider(),
						buildLanguageTile(Icon(Icons.sort_by_alpha), 'Tigrinya'),
						Divider(),
						buildLanguageTile(Icon(Icons.sort_by_alpha), 'Afaan Oromo')
					],
				),
			),
		);
	}

	Widget buildLanguageTile(Widget leading, String label) {
		return InkWell(
			child: Row(
				children: [
					leading,
					VerticalDivider(thickness: 100,),
					Text(label, style: TextStyle(fontWeight: FontWeight.bold),),
				],
			),
			onTap: () {
				Navigator.pop(context);
			},
		);
	}
}