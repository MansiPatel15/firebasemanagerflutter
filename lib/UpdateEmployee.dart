import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UpdateEmployee extends StatefulWidget {
  var docid;

  UpdateEmployee({this.docid});

  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  var operation = "F";
  var select = "p1";
  TextEditingController _name = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _email = TextEditingController();

  ImagePicker _picker = ImagePicker();
  File file;

  var oldfilename = "";
  var cloudimageurl = "";

  getsingledata() async {
    await FirebaseFirestore.instance
        .collection("Employee")
        .doc(widget.docid)
        .get()
        .then((document) {
      setState(() {
        _name.text = document["ename"].toString();
        _contact.text = document["contact"].toString();
        _email.text = document["email"].toString();
        operation = document["gender"].toString();
        select = document["department"].toString();

        oldfilename = document["filename"].toString();
        cloudimageurl = document["fileurl"].toString();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsingledata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("UpdateEmployee"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (file == null)
                    ? (cloudimageurl != "")
                        ? Image.network(cloudimageurl,
                            width: 350.0, height: 150.0)
                        : CircularProgressIndicator()
                    : Image.file(file, width: 350.0, height: 150.0),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: ElevatedButton(
                        onPressed: () async {
                          XFile pickedimage = await _picker.pickImage(
                              source: ImageSource.camera);
                          setState(() {
                            file = File(pickedimage.path);
                          });
                        },
                        child: Text(
                          "Camera",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: ElevatedButton(
                          onPressed: () async {
                            XFile pickedimage = await _picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              file = File(pickedimage.path);
                            });
                          },
                          child: Text(
                            "Gallery",
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                  "Contact : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _contact,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a Contact'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "EmailAddress : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter a Email'),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Gender : ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Radio(
                      groupValue: operation,
                      value: "F",
                      onChanged: (val) {
                        setState(() {
                          operation = val;
                        });
                      },
                    ),
                    Text("Female"),
                    Radio(
                      groupValue: operation,
                      value: "M",
                      onChanged: (val) {
                        setState(() {
                          operation = val;
                        });
                      },
                    ),
                    Text("Male"),
                    Radio(
                      groupValue: operation,
                      value: "O",
                      onChanged: (val) {
                        setState(() {
                          operation = val;
                        });
                      },
                    ),
                    Text("Other"),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Department : ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton(
                      value: select,
                      onChanged: (val) {
                        setState(() {
                          select = val;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text("Purchase Department"),
                          value: "p1",
                        ),
                        DropdownMenuItem(
                          child: Text("Sales Department"),
                          value: "s2",
                        ),
                        DropdownMenuItem(
                          child: Text("Accounting Department"),
                          value: "a3",
                        ),
                        DropdownMenuItem(
                          child: Text("Marketing Department"),
                          value: "m4",
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: ElevatedButton(
                        onPressed: () async {
                          var name = _name.text.toString();
                          var contact = _contact.text.toString();
                          var email = _email.text.toString();

                          if (file == null)
                          {
                            await FirebaseFirestore.instance
                                .collection("Employee")
                                .doc(widget.docid)
                                .update({
                              "ename": name,
                              "contact": contact,
                              "email": email,
                              "gender": operation,
                              "department": select,
                            }).then((value) {
                              setState(() {
                                file = null;
                              });
                              _name.text = "";
                              _contact.text = "";
                              _email.text = "";
                              operation = "";
                              Fluttertoast.showToast(
                                  msg: "Employee Update  Successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            });
                            Navigator.of(context).pop();
                          }
                          else
                          {
                            await FirebaseStorage.instance
                                .ref(oldfilename)
                                .delete()
                                .then((value) async {
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
                                      .collection("Employee")
                                      .doc(widget.docid)
                                      .update({
                                    "ename": name,
                                    "contact": contact,
                                    "email": email,
                                    "gender": operation,
                                    "department": select,
                                    "fileurl": fileurl,
                                    "filename": filename
                                  }).then((value) {
                                    setState(() {
                                      file = null;
                                    });
                                    _name.text = "";
                                    _contact.text = "";
                                    _email.text = "";
                                    operation = "";
                                    Fluttertoast.showToast(
                                        msg: "Employee Updated Successfully",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  });
                                  Navigator.of(context).pop();
                                });
                              });
                            });
                          }
                        },
                        child: Text(
                          "Update",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
