import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'model.dart';
import 'repository.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Guide App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Product Guide'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final List<String> _ingredients = [];
  int itemcount = 0;
  late File imageFile;
  late String image_string;
  Future<data>? _dataModel;

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PRODUCT GUIDE",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 3.0,
                fontFamily: 'FjallaOne',
                color: Colors.white,
              )),
          centerTitle: true,
          backgroundColor: Colors.amber[600],
        ),
        body: Container(
            child: (_dataModel == null)
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber[600],
                            ),
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.all(20.0),
                            child: Text(
                                'Are you safe with these ingredients in your product,\n Scan and know rightaway',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Raleway'))),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.amber,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _getFromGallery();
                                },
                                child: Icon(Icons.photo, size: 30),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.amberAccent,
                                    onPrimary: Colors.black,
                                    padding: EdgeInsets.all(8.0)),
                              ),
                              Text('  Choose photo from Gallery',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Raleway'))
                            ],
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.amber,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _getFromCamera();
                                  },
                                  child: Icon(Icons.camera_enhance_outlined,
                                      size: 30),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.amberAccent,
                                      onPrimary: Colors.black,
                                      padding: EdgeInsets.all(8.0)),
                                ),
                                Text('  Take photo from camera',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Raleway'))
                              ],
                            )),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _dataModel = getData(image_string);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.amberAccent,
                                onPrimary: Colors.black,
                                padding: EdgeInsets.all(8.0)),
                            child: Text("Submit"))
                      ],
                    ),
                  )
                : buildforrec()));
  }

  FutureBuilder<data> buildforrec() {
    return FutureBuilder<data>(
        future: _dataModel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // _ingredients.add(snapshot.data!.recommendation);
            itemcount = snapshot.data!.toxic.length;
            for (var i = 0; i < itemcount; i++) {
              _ingredients.add(snapshot.data!.toxic[i]);
            }
            if (itemcount == 0) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/safetext.JPG'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: itemcount,
                  itemBuilder: (context, j) {
                    return Card(
                      margin: const EdgeInsets.all(12.0),
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ListTile(
                          title: Text(_ingredients[j]),
                          dense: true,
                        ),
                      ),
                    );
                  });
            }
          } else if (snapshot.hasError) {
            return Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                      ),
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(20.0),
                      child: Text(
                        "OOps",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text('${snapshot.error}'),
                  ],
                ));
          }

          return Center(
              child: const CircularProgressIndicator(
            color: Colors.amber,
          ));
        });
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile? image1 = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image1 != null) {
      setState(() {
        imageFile = File(image1.path);
        final bytes = File(image1.path).readAsBytesSync();
        image_string = base64Encode(bytes);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? image1 = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image1 != null) {
      setState(() {
        imageFile = File(image1.path);
        final bytes = File(image1.path).readAsBytesSync();
        image_string = base64Encode(bytes);
      });
    }
  }
}

  // static String _encodeimage(Uint8List data) {
  //   return base64Encode(data);
  // }


// : Center(
                //     child: (toxic == 1)
                    //     ? Container(
                    //         decoration: BoxDecoration(
                    //             color: Colors.red[100],
                    //             border: Border.all(color: Colors.red),
                    //             borderRadius: BorderRadius.circular(30)),
                    //         height: 150,
                    //         width: 150,
                    //         alignment: Alignment.center,
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: <Widget>[
                    //             Icon(
                    //               Icons.cancel_outlined,
                    //               size: 50,
                    //               color: Colors.red[700],
                    //             ),
                    //             RichText(
                    //                 text: TextSpan(
                    //                     style: TextStyle(
                    //                         fontSize: 25, color: Colors.black),
                    //                     children: [
                    //                   TextSpan(
                    //                       text: "Not",
                    //                       style: TextStyle(
                    //                           fontFamily: 'FjallaOne',
                    //                           fontSize: 30,
                    //                           fontStyle: FontStyle.normal,
                    //                           color: Colors.red[500])),
                    //                   TextSpan(
                    //                     text: " Safe",
                    //                   )
                    //                 ])),
                    //           ],
                    //         ))
                    //     : Container(
                    //         decoration: BoxDecoration(
                    //             color: Colors.green[100],
                    //             border: Border.all(color: Colors.green),
                    //             borderRadius: BorderRadius.circular(30)),
                    //         height: 150,
                    //         width: 150,
                    //         alignment: Alignment.center,
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: <Widget>[
                    //             Icon(
                    //               Icons.check_circle_outline,
                    //               size: 50,
                    //               color: Colors.green[700],
                    //             ),
                    //             RichText(
                    //                 text: TextSpan(
                    //                     style: TextStyle(
                    //                         fontSize: 25, color: Colors.black),
                    //                     children: [
                    //                   TextSpan(text: "Safe to"),
                    //                   TextSpan(
                    //                       text: " Buy",
                    //                       style: TextStyle(
                    //                           fontFamily: 'FjallaOne',
                    //                           fontSize: 30,
                    //                           fontStyle: FontStyle.normal,
                    //                           color: Colors.green[500]))
                    //                 ])),
                    //           ],
                    //         ))
                    // //]
                    // ))
        //)