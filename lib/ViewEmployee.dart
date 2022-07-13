import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasemanager/UpdateEmployee.dart';
import 'package:flutter/material.dart';

class ViewEmployee extends StatefulWidget {

  @override
  State<ViewEmployee> createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ViewEmployee"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Employee").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(snapshot.hasData)
            {
              if(snapshot.data.size<=0)
                {
                  return Center(child: Text("No data"),);
                }
              else
                {
                  return ListView(
                    children: snapshot.data.docs.map((document){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 500,
                        color: Colors.purple,
                          margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Image.network(document["fileurl"].toString(),height: 200.0,width: 300,),
                            Divider(
                              color: Colors.white,
                            ),
                            Text(document["ename"].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Divider(
                              color: Colors.white,
                            ),
                            Text(document["contact"].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Divider(
                              color: Colors.white,
                            ),
                            Text(document["email"].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Divider(
                              color: Colors.white,
                            ),
                            Text(document["gender"].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Divider(
                              color: Colors.white,
                            ),
                            Text(document["department"].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Divider(
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: EdgeInsets.all(5)),
                                Container(
                                  width: MediaQuery.of(context).size.width/2.3,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      var docid = document.id.toString();
                                      var imagename = document["filename"].toString();
                                      await FirebaseStorage.instance.ref(imagename).delete().then((value) async{
                                        await FirebaseFirestore.instance.collection("Employee").doc(docid).delete();
                                      });
                                    },
                                    child: Text("Delete"),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                Container(
                                  width: MediaQuery.of(context).size.width/2.3,
                                  child: ElevatedButton(
                                    onPressed: (){
                                      var docid = document.id.toString();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=> UpdateEmployee(docid: docid,))
                                      );
                                    },
                                    child: Text("Update"),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                              ],
                            )
                          ],
                        )
                      );
                    }).toList(),
                  );
                }
            }
          else
            {
              return Center(child: CircularProgressIndicator(),);
            }
        },
      ),
    );
  }
}
