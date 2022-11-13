import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:upload_encoded_image/service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  io.File? imageFile;
  String? imageName;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // image placeholder
            imageFile != null
                ? Image.file(
                    imageFile!,
                    height: 100,
                    width: 100,
                  )
                : const Center(
                    child: Icon(Icons.image),
                  ),
            const SizedBox(height: 10),

            // image file name
            Text("$imageFile"),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () => uploadImageToServer(),
              child: isLoading
                  ? const SizedBox.square(
                      dimension: 60,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Upload'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getImage(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // image picker
  final _service = UploadService();

  Future<void> getImage() async {
    await _service.picImageFile().then((value) {
      if (value != null) {
        setState(() {
          imageFile = value;
        });
      }
    });
  }

  // upload to server
  Future<void> uploadImageToServer() async {
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      await _service.uploadPhoto(imageFile).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      return;
    }
  }
}
