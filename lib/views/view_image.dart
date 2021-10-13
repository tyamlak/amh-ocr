import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import '../providers/api_provider.dart';
import '../providers/db_provider.dart';
import '../providers/data_source.dart';
import '../providers/settings_provider.dart';
import '../models/image_model.dart';
import '../models/glitch.dart';
import '../getit.dart' show getIt;


class ViewTextFromImage extends StatefulWidget {
	final String imagePath;
	final String source;
	ViewTextFromImage(this.imagePath, {this.source='api'});

	createState() => _ViewTextFromImageState();
}

class _ViewTextFromImageState extends State<ViewTextFromImage> {
	bool _isLoading = true;
	bool _hasError = false;
	DataSource _dataSource;
	final _scaffoldState =  GlobalKey<ScaffoldState>();
	final TextEditingController _textController = TextEditingController();
	final _apiProvider = getIt<ApiProvider>();
	final _dbProvider = getIt<DbProvider>();
	final _settingsProvider = getIt<SettingsProvider>();
	final _textInputBorder = OutlineInputBorder(
			borderSide: BorderSide(color: Colors.white, width: 2),
		);

	void initState() {
		_dataSource = widget.source == 'api' ? _apiProvider : _dbProvider;
		_dataSource.readImage(widget.imagePath);
		super.initState();
	}

	void _copyToClipBoard() async {
		await Clipboard.setData(ClipboardData(text: _textController.text));
	}

	saveDocument() async {
		final _image = ImageModel(
			imagePath: widget.imagePath,
			retrievedtext: _textController.text,
		);
		_dbProvider.saveImage(_image);
		_scaffoldState.currentState.showSnackBar(
			SnackBar(
				duration: Duration(seconds: 2),
				content: Text('Image Saved.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
				backgroundColor: Colors.green.shade700,
				action: SnackBarAction(label: 'Undo', textColor: Colors.black, onPressed: () {
					_dbProvider.deleteImageFromCache(_image, removeFile: false);
				}),
			)
		);
	}

	void checkAutoSave() {
		_settingsProvider.initialize()
		.then((int n) {
			if (n == 0) {
				if (_settingsProvider.settingsData.autoSave) {
					saveDocument();
				}
			}
		});
	}
	
	@override 
	Widget build(BuildContext context) {
		return Scaffold(
			key: _scaffoldState,
			appBar: AppBar(
				title:  Text('Amharic OCR'),
				centerTitle: _isLoading,
				actions: [
					_hasError || _isLoading || _dataSource is DbProvider ? Padding(padding: EdgeInsets.zero) : Padding(
						padding: EdgeInsets.only(right:10, top: 5),
						child: IconButton(
							icon: Text('SAVE', style: TextStyle(fontWeight: FontWeight.bold)),
							onPressed: saveDocument,
						),
					),
				],
			),
			body: SingleChildScrollView(
				child: Column(
					children: [ 
						imageWithText(),
					],
				),
			),
			floatingActionButton: _hasError ? retryFloatingButton() 
				: _isLoading ? null : copyToClipboardFloatingButton(),
		);
	}

	Widget imageWithText() {
		return Padding(
			padding: EdgeInsets.all(20),
			child: ClipRRect(
				borderRadius: BorderRadius.circular(10),
				child: Stack(
					children: [
						Image(
							width: MediaQuery.of(context).size.width,
							height: MediaQuery.of(context).size.height * 0.8,
							image: FileImage(File(widget.imagePath)),
						),
						Container(
							width: MediaQuery.of(context).size.width,
							height: MediaQuery.of(context).size.height * 0.8,
							color: Colors.black.withOpacity(0.86)
						),
						_isLoading ? centeredStackElt(CircularProgressIndicator()) : Padding(padding: EdgeInsets.zero,), 
						StreamBuilder(
							stream: _dataSource.retrievedText,
       						// ignore: missing_return
							builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
								if ( snapshot.connectionState == ConnectionState.waiting ){
									return centeredStackElt(CircularProgressIndicator());
								} else if (snapshot.hasError) {
									final Glitch error = snapshot.error as Glitch;
									if (_isLoading) {
										WidgetsBinding.instance.addPostFrameCallback((_) {
											setState((){});
										});
									}
									_hasError = true;
									_isLoading = false;
									return _isLoading ? Divider() : centeredStackElt(
										Text(
											"${error.message}",
											style: TextStyle(
												color: Colors.red,
												fontWeight: FontWeight.bold,
												fontSize: 18,
											),
										),
									);
								} else if (snapshot.hasData) {
									checkAutoSave();
									if (_hasError || _isLoading) {
										WidgetsBinding.instance.addPostFrameCallback((_) {
											setState((){
												_textController.text = snapshot.data;
												_hasError = false;
												_isLoading = false;
											});
										});
									}
									return Positioned(
										left: 30, 
										right: 20,
										top: MediaQuery.of(context).size.height/4.5,
										child: editableReturnedText(),
									);
								}
							},
						),
					],
				),
			),
		);
	}

	Widget editableReturnedText() {
		return Padding(
			padding: EdgeInsets.all(10),
			child: TextField(
				controller: _textController,
				maxLines: 12,
				keyboardType: TextInputType.multiline,
				textCapitalization: TextCapitalization.sentences,
				style: TextStyle(
					color: Colors.white,
					fontWeight: FontWeight.bold,
				),
				decoration: InputDecoration(
					labelText: "Returned Text",
					labelStyle: TextStyle(color: Colors.lime),
					enabledBorder: _textInputBorder,
					focusedBorder: _textInputBorder,
				),
			),
		);
	}

	Widget centeredStackElt(Widget child) {
		return Positioned(
			top: MediaQuery.of(context).size.height/3,
			left: 35,
			child: child,
		);
	}

	Widget retryFloatingButton() {
		return FloatingActionButton(
			child: Icon(Icons.refresh),
			onPressed: () {
				if (_isLoading) {
					return;
				} else {
					setState(() {
						_isLoading = true;
						_apiProvider.readImage(widget.imagePath);
					});
				}
			},
		);
	}

	Widget copyToClipboardFloatingButton() {
		return FloatingActionButton(
			backgroundColor: Colors.blueGrey[800],
			child: Icon(Icons.copy, color: Colors.limeAccent),
			onPressed: _copyToClipBoard,
			tooltip: "Copy to Clipboard",
		);
	}

}