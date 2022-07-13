import 'package:firebasemanager/FirebaseAuthentication.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var name="",email="",photo="",googleid="";

  getdata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name");
      email = prefs.getString("email");
      photo = prefs.getString("photo");
      googleid = prefs.getString("googleid");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      // body:  Center(
      //     child: ElevatedButton(
      //       onPressed: (){},
      //       child: Text("Logout",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      //     ),
      // ),
      body: Container(
        color: Color(0xFFbbdefb),
        width: MediaQuery.of(context).size.width,
      height: 300,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child:Column(
          children: [
            Text("Name : "+name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            Divider(
              color: Colors.black,
              height: 20,
              thickness: 3,
            ),
            Text("Email : "+email,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            Divider(
              color: Colors.black,
              thickness: 3,
              height: 20,
            ),
            Text("Photo : "+photo,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            Divider(
              color: Colors.black,
              height: 20,
              thickness: 3,
            ),
            Text("GoogleId : "+googleid,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),),
            Divider(
              color: Colors.black,
              height: 20,
              thickness: 3,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove("islogin");

                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.signOut();

                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> FirebaseAuthentication())
                  );
                },
                child: Text("LogOut",style: TextStyle(fontSize: 20),)
            ),
          ],
        ),
      ),
      ),
    );
  }
}
