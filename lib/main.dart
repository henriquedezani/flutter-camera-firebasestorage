import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StoragePage()
    );
  }
}

class StoragePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return StoragePageState();
  }  
}

class StoragePageState extends State<StoragePage>
{
  String url;
  File image;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera/Storage"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.camera_alt), onPressed: () { this.getCameraImage(); },),
          IconButton(icon: Icon(Icons.photo), onPressed: () { this.getGalleryImage(); },)
        ],
      ),
      body: ListView(
        children: <Widget>[
          image == null ? Center(child: Text("Use as actions buttons acima!")) : imageUpload(),
          url == null ? Center(child: Container(child: Placeholder(), width: 300, height: 300,)) : Image.network(url, width: 300, height: 300,)
        ],
      )
    );
  }

  Widget imageUpload()
  {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(image, height: 300, width: 300),
          RaisedButton(
            child: Text("Upload"),
             color: Colors.blue,
             onPressed: upload,
          )
        ],
      ),
    );
  }

  Future upload() async {
    String filename = DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
    final StorageReference storageRef = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask upload = storageRef.putFile(this.image);

    StorageTaskSnapshot snapshot = await upload.onComplete;
    snapshot.ref.getDownloadURL().then((downloadUrl) {
      setState(() {
        url = downloadUrl;
      });
    });
  }

  Future getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 300, maxWidth: 300);

    setState(() {
      this.image = image;
    });
  }  

  Future getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);

    setState(() {
      this.image = image;
    });
  } 
}