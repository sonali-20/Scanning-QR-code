import 'package:flutter/material.dart';
import  'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'shoppinglist.dart';
import 'login_page.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

enum ConfirmAction { CANCEL, ACCEPT }
 
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create User'),
        content: const Text(
            'Created User. Please Login'),
        actions: <Widget>[
          FlatButton(
            child: const Text('ACCEPT'),
            onPressed: () {
              Navigator.of(context).pushNamed(LoginPage.tag);
            },
          )
        ],
      );
    },
  );
}

class Post {
  final String body;
  final String uname;
  Post({this.body,this.uname});
 
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      body: json['body'],
      uname:json['uname']
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["body"] = body;
    map["uname"]=uname;
 
    return map;
  }
}

Future<Post> createPost(String url, Map v) async {
  print(v);
  var body = json.encode(v);
  return http.post(url,headers: {"Content-Type": "application/json"},body:body).then((http.Response response) {
    final int statusCode = response.statusCode;
 
    if (statusCode < 200 || statusCode > 400 ) {
      print("printing error");
      throw new Exception("Error while fetching data");
    }
    print ("till fianl");

    return Post.fromJson(json.decode(response.body));
  });
}
class SignupPage extends StatefulWidget {
  static String tag = 'signup-page';
  @override
  _SignupPageState createState() => new _SignupPageState();
}


class _SignupPageState extends State<SignupPage> {
  // String url = "";
  // Future <String> makerequest() async {
  // var response = await http.post
  //(Uri.encodeFull(url), headers: {"Accept" :  })
  // }


  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final myemail = TextEditingController();
  final mypassword = TextEditingController();
  final myname = TextEditingController();
  final myaddress = TextEditingController();
  final myphoneno = TextEditingController();
  bool _validate = false;


  @override
  void dispose() {
    myname.dispose();
    myaddress.dispose();
    myphoneno.dispose();
    myemail.dispose();
    mypassword.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.jpg'),
      ),
    );

    String validateEmail(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Enter Valid Email';
      else
        return null;
    }


    final email = TextFormField(

//      validator: (val) => !EmailValidator.Validate(val, true)
//          ? 'Not a valid email.'
//          : null,
    validator: validateEmail,
      controller: myemail,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      //initialValue: 'ShashankTest',
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        //errorText: _validate ? 'Value Can\'t Be Empty' : null,
      ),

    );



    final password = TextFormField(
      controller: mypassword,
      autofocus: false,
      //initialValue: '55',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
      ),
    );


    final address = TextFormField(
      controller: myaddress,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Address',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
      ),
    );

    final phoneno = TextFormField(
      controller: myphoneno,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Phone No.',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
      ),
    );

    final name = TextFormField(
      controller: myname,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
      ),
    );





    final signupButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async{

          var email = myemail.text;
          var password = mypassword.text;
          var address = myaddress.text;
          var name =myname.text;
          var phoneno =myphoneno.text;
          Map map = {
    "uname":email ,
    "password":password,
    "address":address,
    "phoneno":phoneno
  };
          Post p = await createPost("https://boschapitest1.azurewebsites.net/user",map);
                    print("error nahi h");
                    print(p.uname);
                    if(p.uname==email){
                      print("bangya user");
                      _asyncConfirmDialog(context);
                    }else{
                      print("pehele se h");
                    }

          
                    
                  


          setState(() {
            myemail.text.isEmpty ? _validate = true : _validate = false;
            mypassword.text.isEmpty ? _validate = true : _validate = false;
          });

        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Signup', style: TextStyle(color: Colors.white)),
      ),
    );


    final haveAccountLabel = FlatButton(
      child: Text(
        'Already have an account? Login',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {

        Navigator.of(context).pushNamed(LoginPage.tag);
      },
    );


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 8.0),
            name,
            SizedBox(height: 8.0),
            address,
            SizedBox(height: 8.0),
            phoneno,
            SizedBox(height: 8.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            signupButton,
            haveAccountLabel,
          ],
        ),
      ),
    );
  }
}



