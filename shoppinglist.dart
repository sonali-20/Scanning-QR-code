import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';


class ShoppingList extends StatefulWidget {
  static String tag = 'shopping-list';
  final String text;
  ShoppingList({Key key, @required this.text}) : super(key: key);
  @override
  _ShoppingListState createState() => new _ShoppingListState(text);
}

class _ShoppingListState extends State<ShoppingList>
{
  String text;
  _ShoppingListState(this. text);

  TextEditingController eCtrl =new TextEditingController();
  bool showDialog = false;
  List<String> textList = [];
  List<bool> textChkBox = [];
  @override
  Widget build(BuildContext ctxt)
  {

    widget.text;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Shopping List"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.add_to_queue),
                onPressed:()
                {
                  setState(()
                  {

                    showDialog= true;
                  });
                }
            ),
            new IconButton(
                icon: new Icon(Icons.remove),
                onPressed:()
                {
                  int counter=0;
                  while(counter < textList.length) {
                    if(textChkBox[counter] ==true) {
                      textChkBox.removeAt(counter);
                      textList.removeAt(counter);
                      counter = 0;
                    } else {
                      counter++;
                    }
                  }
                  setState(()
                  {});
                }
            ),
            new IconButton(
                icon: new Icon(Icons.add_shopping_cart),
                onPressed:()
                {
                  Navigator.of(context).pushNamed(HomePage.tag);
                  setState(()
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(text: text),
                        ));
                  });
                }
            ),
          ],
        ),
        body: new Column(
          children: <Widget>[
            showDialog == true?
            new AlertDialog(
              title: new Text("New Item"),
              content: new TextField
                (
                controller: eCtrl,
                decoration: new InputDecoration.collapsed(hintText: "Item Name"),
                maxLines: 1,
                onSubmitted: (String text) {

                },
              ),

              actions: <Widget>[
                new FlatButton(
                    onPressed: (){


                      var itemName =eCtrl.text;

                      var client = http.Client();
                      var response= client.post('https://boschapitest1.azurewebsites.net/userScart',

                        headers:{"Content-Type":"application/json"},
                        body: """{"uname":"$text",
                                  "name":"$itemName",
                                  "quantity": "1"
                                  }""",
                      ).whenComplete(client.close);
                      print(response);
                      setState(()
                      {


                        showDialog=false;
                        textChkBox.add(false);
                        textList.add(eCtrl.text);
                        eCtrl.clear();


                      });
                    },
                    child: new Text("OK")
                )
              ],
            ): new Text(" "),
            new Flexible(
                child: new ListView.builder(

                    itemCount: textList.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Row(

                          children: <Widget>[
                            new Checkbox(

                              value: textChkBox[index],
                              onChanged: (bool newValue){
                                textChkBox[index] = newValue;
                                setState(() {});
                              },
                            ),
                            new Text(textList[index]),

                          ]

                      );

                    }
                )

            )
          ],
        )
    );
  }
}