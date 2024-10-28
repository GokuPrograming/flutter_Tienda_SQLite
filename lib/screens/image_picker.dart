import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:images_picker/images_picker.dart';


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? path;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              child: Text('pick'),
              onPressed: () async {
                List<Media>? res = await ImagesPicker.pick(
                  count: 3,
                  pickType: PickType.all,
                  language: Language.System,
                  maxTime: 30,
                  // maxSize: 500,
                  cropOpt: CropOption(
                    // aspectRatio: CropAspectRatio.wh16x9,
                    cropType: CropType.circle,
                  ),
                );
                print(res);
                if (res != null) {
                  print(res.map((e) => e.path).toList());
                  setState(() {
                    path = res[0].thumbPath;
                  });
                  // bool status = await ImagesPicker.saveImageToAlbum(File(res[0]?.path));
                  // print(status);
                }
              },
            ),
            ElevatedButton(
              child: Text('openCamera'),
              onPressed: () async {
                List<Media>? res = await ImagesPicker.openCamera(
                  // pickType: PickType.video,
                  pickType: PickType.image,
                  quality: 0.8,
                  maxSize: 800,
                  // cropOpt: CropOption(
                  //   aspectRatio: CropAspectRatio.wh16x9,
                  // ),
                  maxTime: 15,
                );
                print(res);
                if (res != null) {
                  print(res[0].path);
                  setState(() {
                    path = res[0].thumbPath;
                  });
                }
              },
            ),
            path != null
                ? Container(
                    height: 200,
                    child: Image.file(
                      File(path!),
                      fit: BoxFit.contain,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
