import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:r_scanner/screen/text_convertor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:translator/translator.dart';

class homess extends StatefulWidget {
  const homess({super.key});

  @override
  State<homess> createState() => _homesState();
}

class _homesState extends State<homess> {
  bool textscanning = false;
  bool pop_close = false;
  XFile? imageFile;
  String scaned_text = '';
  String Texts = '';
  int count = 1;
  String send_scaned_text = '';

  final _f2 = GlobalKey<FormState>();
  GoogleTranslator translator = GoogleTranslator();

  void getimage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        textscanning = true;
        imageFile = pickedImage;
        setState(() {});
        get_recognized_text(pickedImage);
      }
    } catch (e) {
      textscanning = false;
      imageFile = null;
      setState(() {
        scaned_text = "Error";
      });
    }
  }

  void getimage_using_camera() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (pickedImage != null) {
        textscanning = true;
        imageFile = pickedImage;
        setState(() {});
        get_recognized_text(pickedImage);
      }
    } catch (e) {
      textscanning = false;
      imageFile = null;
      setState(() {
        scaned_text = "Error";
      });
    }
  }

  void get_recognized_text(XFile image) async {
    try {
      final InputImages = InputImage.fromFilePath(image.path);
      final TextDetector = GoogleMlKit.vision.textRecognizer();
      RecognizedText recognizedText =
          await TextDetector.processImage(InputImages);
      await TextDetector.close();
      scaned_text = " ";
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          setState(() {
            scaned_text = scaned_text + line.text + "\n";
          });
        }
        count++;
      }
      setState(() {
        textscanning = false;
      });
    } catch (e) {
      return;
    }
  }

  void pop_up_button(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            child: Wrap(
              children: [
                Container(
                  child: new ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    onTap: () {
                      scaned_text = '';
                      getimage_using_camera();
                      Navigator.pop(context);

                      CircularPercentIndicator(radius: 21);
                    },
                    leading: Icon(
                      Icons.camera_alt_rounded,
                    ),
                    title: Text(
                      'Camera',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: new ListTile(
                    onTap: () {
                      scaned_text = '';
                      getimage();
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.photo),
                    title: Text('Galary'),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget box() {
    return Container(
      width: 300,
      height: 300,
      color: Color.fromRGBO(91, 85, 85, 0.332),
      alignment: Alignment.center,
    );
  }

  Widget convert_btn() {
    return ElevatedButton(
        onPressed: () {
          count = 1;

          pop_up_button(context);
        },
        child: Text(
          'Convert',
          style: TextStyle(fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
            foregroundColor: Color.fromARGB(255, 255, 255, 255),
            backgroundColor: Color.fromRGBO(53, 43, 240, 0.721),
            padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            )));
  }

  Widget translate_btn() {
    return ElevatedButton(
        onPressed: () {
          _f2.currentState!.save();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => translate_ful(
                      main_scanned_text: send_scaned_text, count: count)));
        },
        child: Text(
          'Translate',
          style: TextStyle(fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
            foregroundColor: Color.fromARGB(255, 255, 255, 255),
            backgroundColor: Color.fromRGBO(53, 43, 240, 0.721),
            padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              try {
                Navigator.pop(context);
              } catch (e) {
                print(e);
              }
            },
            icon: Icon(Icons.arrow_back_ios_new_sharp),
          ),
          automaticallyImplyLeading: false,
          title: Text('Convertor'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(16, 67, 195, 0.818),
                  Color.fromRGBO(13, 3, 216, 0.877)
                ], begin: Alignment.bottomLeft, end: Alignment.topCenter),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(30))),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Form(
              key: _f2,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  if (!textscanning && imageFile == null)
                    Center(
                      child: box(),
                    ),
                  if (imageFile != null) Image.file(File(imageFile!.path)),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      convert_btn(),
                      SizedBox(
                        width: 10,
                      ),
                      translate_btn(),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: textscanning
                          ? CircularPercentIndicator(
                              animation: true,
                              animationDuration: 12000,
                              progressColor: Color.fromARGB(153, 31, 38, 220),
                              radius: 80,
                              lineWidth: 20,
                              circularStrokeCap: CircularStrokeCap.round,
                              percent: 1,
                              center: Text(
                                'Converting...',
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          : Container(
                              width: 350,
                              child: Center(
                                child: TextFormField(
                                  //text form fieled element
                                  maxLines: count,
                                  initialValue: '$scaned_text',
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),

                                  onChanged: (Text) {
                                    send_scaned_text = Text;
                                  },
                                  onSaved: (Text) {
                                    send_scaned_text = Text.toString();
                                  },
                                ),
                              ),
                            )),
                ],
              ),
            ),
          ),
        ));
  }
}
