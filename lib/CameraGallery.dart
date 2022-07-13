import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraGallery extends StatefulWidget {

  @override
  State<CameraGallery> createState() => _CameraGalleryState();
}

class _CameraGalleryState extends State<CameraGallery> {

  ImagePicker _picker = ImagePicker();
  File file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CameraGalleryExample"),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child :Column(
          children: [
            Image.asset("Image/1.jpg"),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2.2,
                  child:ElevatedButton(
                    onPressed: () async {
                      XFile pickedimage = await _picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        file = File(pickedimage.path);
                      });
                    },
                    child: Text("Camera",style: TextStyle(fontSize: 20),),
                  ) ,
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: MediaQuery.of(context).size.width/2.2,
                  child:ElevatedButton(
                    onPressed: () async {
                      XFile pickedimage = await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        file = File(pickedimage.path);
                      });
                    },
                    child: Text("Gallery",style: TextStyle(fontSize: 20),),
                  )
                ),
              ],
            ),
          ],
        ),
      )
      ),
    );
  }
}
