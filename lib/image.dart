import 'package:flutter/material.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';




class MyRay extends StatelessWidget {
  const MyRay({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Ray(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Ray extends StatefulWidget {
  const Ray({Key? key}) : super(key: key);

  @override
  State<Ray> createState() => _RayState();
}

class _RayState extends State<Ray> {
  File? image;
  final imagepicker = ImagePicker();
  String predictionResult = "";


  uploadImage() async {
    setState(() {
      predictionResult = "Loading";
    });
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    } else {}

    // encode the image as base64 string
    final bytes = await image!.readAsBytes();
    final String img64 = base64Encode(bytes);

    // create the request body
    final Map<String, dynamic> body = {
      'image': img64,
    };

    // make the API request
    final response = await http.post(
      Uri.parse('http://132.145.71.167:5000/predict'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    // parse the response and get the prediction result
    final Map<String, dynamic> prediction = json.decode(response.body)['prediction'];
    setState(() {
      predictionResult = prediction['result'];
    });


  }

  uploadGallery() async {
    setState(() {
      predictionResult = "Loading";
    });
    var pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    } else {}

    // encode the image as base64 string
    final bytes = await image!.readAsBytes();
    final String img64 = base64Encode(bytes);

    // create the request body
    final Map<String, dynamic> body = {
      'image': img64,
    };

    // make the API request
    final response = await http.post(
      Uri.parse('http://132.145.71.167:5000/predict'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    // parse the response and get the prediction result
    final Map<String, dynamic> prediction = json.decode(response.body)['prediction'];
    setState(() {
      predictionResult = prediction['result'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'X_Ray',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
              onPressed: onNotification,
              icon: Icon(
                Icons.notification_important,
                size: 30,
              )),
          IconButton(
              onPressed: () {
                print('hello');
              },
              icon: Icon(
                Icons.search,
                size: 30,
              ))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          image == null
              ? Text(
            'Not choosen Image',
            style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          )
              : Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(15),
            ),
            width: 400,
            height: 300,
            child: Image.file(
              image!,
            ),
          ),
          SizedBox(height: 50),
          predictionResult.isNotEmpty
              ? Text(
            'Prediction Result: $predictionResult',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          )
              : Container(),
          SizedBox(height: 50),
          Center(
            child: ElevatedButton(
              onPressed: uploadGallery,
              child: Text(
                'X_Ray from Gallery',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.all(
                    10,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: uploadImage,
              child: Text(
                'X_Ray from Camera',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.all(
                    10,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),

        ],
      ),
    );
  }

  void onNotification() {
    print('hello');
  }
}


