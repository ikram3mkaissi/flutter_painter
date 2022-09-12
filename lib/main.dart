import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'package:fireworks/provider/option_model.dart';
import 'package:fireworks/provider/points.model.dart';
import 'package:flutter/material.dart';
import 'canvas.dart';
import 'bottom_sheet.dart' as BSheet;
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:gallery_saver/gallery_saver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  late Uint8List _imageFile;
  final snackBar = SnackBar(
    content: Text('Image s saved'),
  );
  ScreenshotController screenshotController = ScreenshotController();
  void capture() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you really like to save this image?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Exit',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Approve'),
              onPressed: () async {
                print('capture called');
                await screenshotController
                    .capture(delay: const Duration(milliseconds: 10))
                    .then((Uint8List? image) async {
                  if (image != null) {
                    final directory = await getApplicationDocumentsDirectory();
                    final imagePath =
                        await File('${directory.path}/image.png').create();
                    await imagePath.writeAsBytes(image);
                    GallerySaver.saveImage(imagePath.path);
                  }
                }).then((value) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });Provider.of<pointsModel> (context,listen: false).center=[];
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) =>
                  optionModel(option_type.pen, Colors.red, Size(1, 1))),
          ChangeNotifierProvider(create: (context) => pointsModel([]))
        ],
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Consumer<optionModel>(builder: (context, option, child) {
                  return Screenshot(
                      controller: screenshotController,
                      child: Consumer<pointsModel>(
                          builder: (context, points, child) {
                        return Canvas(option: option,points:points);
                      }));
                }),
                BSheet.BottomSheet(capture: capture),
              ],
            )));
  }
}
