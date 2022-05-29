import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';
import 'package:flutter_image_picker_2/safe_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'model.dart';
import 'safe_screen.dart';
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
      initialRoute: '/',
      routes: {
        '/safe_screen': (context) => SafeScreen(),
      },
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
  late int image_entity = 0;
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
                      children: (image_entity == 1)
                          ? <Widget>[
                              Column(
                                  // Slide button for submit
                                  children: [
                                    SliderButton(
                                      action: () async {
                                        setState(() {
                                          _dataModel = getData(image_string);
                                        });
                                      },
                                      label: Text("Upload",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Raleway')),
                                      boxShadow: BoxShadow(
                                        color: Colors.orange,
                                        blurRadius: 4,
                                      ),
                                      icon: Icon(Icons.cloud_upload_outlined),
                                      buttonColor: Colors.white,
                                      backgroundColor: Colors.amber,
                                      highlightedColor: Colors.white,
                                      baseColor: Colors.black,
                                    ),
                                    Container(
                                      height: 50.0,
                                    )
                                  ])
                            ]
                          : <Widget>[
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber,
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  margin: EdgeInsets.all(20.0),
                                  child: Text(
                                      'Are you safe with these ingredients in your product?\n Scan and know rightaway',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Raleway'))),
                              SliderButton(
                                action: () {
                                  _getFromGallery();
                                },
                                label: Text("From Gallery",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Raleway')),
                                boxShadow: BoxShadow(
                                  color: Colors.orange,
                                  blurRadius: 4,
                                ),
                                icon: Icon(Icons.photo),
                                buttonColor: Colors.white,
                                backgroundColor: Colors.orangeAccent,
                                highlightedColor: Colors.white,
                                baseColor: Colors.black,
                              ),
                              Container(height: 20.0),
                              SliderButton(
                                action: () {
                                  _getFromCamera();
                                },
                                label: Text("From Camera",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Raleway')),
                                boxShadow: BoxShadow(
                                  color: Colors.orange,
                                  blurRadius: 4,
                                ),
                                icon: Icon(Icons.camera_enhance_outlined),
                                buttonColor: Colors.white,
                                backgroundColor: Colors.amber,
                                highlightedColor: Colors.white,
                                baseColor: Colors.black,
                              ),
                              Container(height: 20.0),
                            ],
                    ),
                  )
                : buildforrec()));
  }

  //Next screen for the future
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
              return SafeScreen();
            } else {
              return Column(children: [
                Image.asset('assets/images/unsafe_image.JPG'),
                Text(
                  'This product contains harmful ingredients',
                  style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Raleway'),
                ),
                Expanded(
                    child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                      shrinkWrap: true,
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
                              title: Text(_ingredients[j],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Raleway')),
                              trailing: Icon(
                                Icons.close,
                                color: Colors.redAccent,
                              ),
                              dense: true,
                            ),
                          ),
                        );
                      }),
                ))
              ]);
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
        image_entity = 1;
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
        image_entity = 1;
      });
    }
  }
}
