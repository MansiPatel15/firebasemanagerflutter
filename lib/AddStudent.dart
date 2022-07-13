import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddStudent extends StatefulWidget {

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController _rollno =TextEditingController();
  TextEditingController _name =TextEditingController();
  TextEditingController _s1 =TextEditingController();
  TextEditingController _s2 =TextEditingController();
  TextEditingController _s3 =TextEditingController();
  ImagePicker _picker = ImagePicker();
  File file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AddStudentExample"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (file==null)?Image.asset("Image/3.png",width: 350,height: 150,):Image.file(file,width: 350,height: 150,),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2.3,
                    child:ElevatedButton(
                      onPressed: () async
                      {
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
                      width: MediaQuery.of(context).size.width/2.3,
                      child:ElevatedButton(
                        onPressed: () async
                        {
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
              SizedBox(
                height: 10,
              ),
              Text(
                "Roll No : ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _rollno,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter a Roll No'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Name : ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter a Name'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Subject1 : ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _s1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter a Subject1'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Subject2 : ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _s2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter a Subject2'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Subject3 : ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _s3,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter a Subject3'),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2.2,
                    child: ElevatedButton(
                      onPressed: () async {
                        var rollno = _rollno.text.toString();
                        var name = _name.text.toString();
                        var subject1 = _s1.text.toString();
                        var subject2 = _s2.text.toString();
                        var subject3 = _s3.text.toString();
                        var total = int.parse(subject1) +int.parse(subject2)+int.parse(subject3);
                        var percentage = total/3;

                        var uuid = Uuid();
                        var filename = uuid.v1().toString() +
                            ".jpg"; //6c84fb90-12c4-11e1-840d-7b25c5ee775a.jpg

                        await FirebaseStorage.instance
                            .ref(filename)
                            .putFile(file)
                            .whenComplete(() {})
                            .then((filedata) async {
                          await filedata.ref
                              .getDownloadURL()
                              .then((fileurl) async {
                            await FirebaseFirestore.instance
                                .collection("Student")
                                .add({
                              "rollno": rollno,
                              "name": name,
                              "subject1": subject1,
                              "subject2": subject2,
                              "subject3": subject3,
                              "total": total,
                              "percentage": percentage,
                              "fileurl":fileurl,
                              "filename":filename
                            }).then((value) {
                              setState(() {
                                file=null;
                              });
                              _name.text = "";
                              _name.text = "";
                              _rollno.text = "";
                              _name.text = "";
                              _s1.text = "";
                              _s2.text = "";
                              _s3.text = "";
                              Fluttertoast.showToast(
                                  msg: "Student Inserted Successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            });
                          });
                        });
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/2.2,
                    child: ElevatedButton(
                      onPressed: (){},
                      child: Text("Cancel",style: TextStyle(fontSize: 20),),
                    ) ,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
