import 'package:flutter/material.dart';
import 'package:r_scanner/screen/mains.dart';
import 'package:translator/translator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class translate_ful extends StatefulWidget {
  String main_scanned_text;
  int count;
  translate_ful({required this.main_scanned_text, required this.count});

  @override
  State<translate_ful> createState() =>
      _translate_fulState(main_scanned_text: main_scanned_text, count: count);
}

class _translate_fulState extends State<translate_ful> {
  String main_scanned_text;
  String sinhala = '';
  int count;
  bool translating = false;
  final _f3 = GlobalKey<FormState>();
  _translate_fulState({required this.main_scanned_text, required this.count});

  GoogleTranslator translator = GoogleTranslator();

  void translators() {
    try {
      translator.translate(main_scanned_text, to: "si").then((output) {
        try {
          setState(() {
            sinhala = output.text;
            translating = false;
          });
        } catch (e) {
          return ('Your Network is Unstable');
        }
      });
    } catch (e) {}
  }

  Widget sinhala_text() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Text(
          '$sinhala',
        ),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(border: Border.all()),
      ),
    );
  }

  Widget translate_btn() {
    return ElevatedButton(
        onPressed: () {
          if (_f3.currentState!.validate()) {
            _f3.currentState!.save;

            setState(() {
              translating = true;
              translators();
            });
          }
        },
        child: Text(
          'Translate To Sinhala',
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

  Widget English_text() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: TextFormField(
          initialValue: '$main_scanned_text',
          maxLines: count,
          decoration: InputDecoration(border: OutlineInputBorder()),
          onChanged: (Text) {
            main_scanned_text = Text.toString();
          },
          validator: (Text) {
            if (Text.toString().length == 0 ||
                (Text.toString()).trim().isEmpty) {
              return ('This Field is Empty Or Include Space Only');
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget indicator() {
    return Container(
        child: translating
            ? CircularPercentIndicator(
                animation: true,
                progressColor: Color.fromARGB(153, 31, 38, 220),
                animationDuration: 5000,
                radius: 80,
                lineWidth: 20,
                circularStrokeCap: CircularStrokeCap.round,
                percent: 1,
                center: Text(
                  'Translating...',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : sinhala_text());
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
        title: Text('Translator'),
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
                  bottomRight: Radius.circular(25))),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _f3,
          child: Column(
            children: [
              English_text(),
              translate_btn(),
              SizedBox(
                height: 10,
              ),
              indicator(),
            ],
          ),
        ),
      ),
    );
  }
}
