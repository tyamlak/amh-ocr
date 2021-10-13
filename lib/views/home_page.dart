import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/db_provider.dart';
import '../widgets/image_tile.dart';
import '../widgets/empty_doc.dart';
import '../models/image_model.dart';
import '../getit.dart' show getIt;


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final cameraAssetImage = const AssetImage('assets/camera.jpg');
  final galleryAssetImage = const AssetImage('assets/gallery.png');
  final DbProvider _dbProvider = getIt<DbProvider>();

  Color _speedDialLabelColor = Colors.white70;
  TextStyle _speedDialChildTextStyle = TextStyle(
	  color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  retrieveText(PickedFile image) {
    if (image != null) {
      Navigator.pushNamed(context, 'viewTextImage', arguments: image.path);
    }
  }

  initState() {
    _dbProvider.getLocalImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    	appBar: AppBar(
   			title: Text(widget.title),
		    actions: [
				Padding(
					padding: EdgeInsets.all(5),
					child: IconButton(
						icon: Icon(Icons.settings,),
						onPressed: () {
							Navigator.pushNamed(context, 'appSettings');
						},
					),
				),
		    ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _dbProvider.getLocalImages();
        },
        child: StreamBuilder(
          stream: _dbProvider.localImages,
          builder: (context, AsyncSnapshot<List<ImageModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (index  >= snapshot.data.length) {
                    return null;
                  }
                  return ImageTile(snapshot.data[snapshot.data.length - 1 - index ]);
                },
              );
            } else {
              return Center(child: EmptyDocument(),);
            }
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        curve: Curves.bounceInOut,
        buttonSize: 60,
        overlayColor: Colors.transparent,
        tooltip: "Choose Image",
        iconTheme: IconThemeData(color:Colors.white, size: 30),
        activeIcon: Icons.cancel,
        label: Icon(Icons.camera, size: 30, color: Colors.limeAccent),
        icon: Icons.add,
        activeLabel: Icon(Icons.cancel),
        backgroundColor: Colors.black87,
        children: <SpeedDialChild>[
          SpeedDialChild(
            label: "Camera",
            labelBackgroundColor: _speedDialLabelColor,
            labelStyle: _speedDialChildTextStyle,
            child: Image(
              image: cameraAssetImage,
            ),
            onTap: () async {
              final picker = ImagePicker();
              final PickedFile selectedImage = await picker.getImage(source: ImageSource.camera);
              retrieveText(selectedImage);
            }
          ),
          SpeedDialChild(
            backgroundColor: Colors.black,
            label: "Gallery",
            labelBackgroundColor: _speedDialLabelColor,
            labelStyle: _speedDialChildTextStyle,
            child: Image(
              image: galleryAssetImage
            ),
            onTap: () async {
              final picker = ImagePicker();
              final selectedImage = await picker.getImage(source: ImageSource.gallery);
              retrieveText(selectedImage);
            }
          ),
        ],
      ),
    );
  }
}
