import 'package:flutter/material.dart';
import  'package:http/http.dart' as http;
import 'shoppinglist.dart';
import 'dart:async';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'dart:io';



enum ConfirmAction { CANCEL, ACCEPT }
 
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Login'),
        content: const Text(
            'Login Successful'),
        actions: <Widget>[
          FlatButton(
            child: const Text('ACCEPT'),
            onPressed: () {

              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(ShoppingList.tag);

            },
          )
        ],
      );
    },
  );
}


Future<ConfirmAction> _asyncError(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Login'),
        content: const Text(
            'Login Unsuccessful Please try again'),
        actions: <Widget>[
          FlatButton(
            child: const Text('OK'),
            onPressed: () {

              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(LoginPage.tag);

            },
          )
        ],
      );
    },
  );
}
class Post {
  final String userId;
  final int id;
  final String title;
  final String body;
 
  Post({this.userId, this.id, this.title, this.body});
 
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

 
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userId"] = userId;
    map["title"] = title;
    map["body"] = body;
 
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



class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // String url = "";
  // Future <String> makerequest() async {
  // var response = await http.post
  //(Uri.encodeFull(url), headers: {"Accept" :  })
  // }
  final myemail = TextEditingController();
  final mypassword = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
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


    final email = TextFormField(
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
      validator: (val) => !EmailValidator.Validate(val, true)
          ? 'Not a valid email.'
          : null,
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




    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: ()  async {
                    var email=myemail.text;
                    var password=mypassword.text;
                    Map map = {
    'uname':email ,
    'password':password
  };
                   Post p = await createPost("https://boschapitest1.azurewebsites.net/userCheck",map);
                   print("error nahi h");
                   print(p.body);
                    if(p.body=="true")
                    {
                      _asyncConfirmDialog(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShoppingList(text: myemail.text),
                          ));
                    }
                    else
                      {
                      _asyncError(context);
                    }

          setState(() {
            myemail.text.isEmpty ? _validate = true : _validate = false;
            mypassword.text.isEmpty ? _validate = true : _validate = false;


          });
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );


    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}