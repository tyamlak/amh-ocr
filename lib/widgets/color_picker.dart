import 'package:flutter/material.dart';


class ColorPicker extends StatefulWidget {
	final Color selectedColor;
	final List<Color> availableColors;
	final Function onColorChange;
	ColorPicker(this.availableColors, this.onColorChange, {this.selectedColor=Colors.black});

	createState() => _ColorPickerState(selectedColor);

}

class _ColorPickerState extends State<ColorPicker> {
	Color selectedColor;

	_ColorPickerState(this.selectedColor);

	@override
	Widget build(BuildContext context) {
		return AlertDialog(
			title: Text('Select Color'),
			insetPadding: EdgeInsets.all(20),
			content: Container(
				width: MediaQuery.of(context).size.width,
				height: 50,
				padding: EdgeInsets.all(5),
				child: ListView.builder(
					scrollDirection: Axis.horizontal,
					itemCount: widget.availableColors.length,
					itemBuilder: (BuildContext context, int index) {
						final color = widget.availableColors[index];
						return colorBox(context, color, selected: selectedColor == color);
					},
				),
			),
		);
	}

	Widget colorBox(BuildContext context, Color color, {bool selected=false}) {
		return GestureDetector(
			child: Container(
				height: 40,
				width: 55,
				decoration: BoxDecoration(
					shape: BoxShape.circle,
					color: color,
				),
				child: selected ? const Center(child: Icon(Icons.check, color:Colors.black),) : const Padding(padding: EdgeInsets.zero),
			),
			onTap: () {
				setState(() {
					selectedColor = color;
					widget.onColorChange(color);
				});
			},
		);
	}
}