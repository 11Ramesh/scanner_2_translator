import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class about extends StatefulWidget {
  const about({super.key});

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
  Widget build(BuildContext context) {
    Future<void> _launchURL() async {
      final url =
          Uri.parse('https://linkedin.com/in/ramesh-madhuranga-3b7027286/');
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        print('Error launching URL: $e');
      }
    }

    @override
    String t =
        'I am Gamage Don Ramesh Maduranga, a postgraduate student at the University of Kelaniya, Sri Lanka.';

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
        title: Text('About Us'),
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
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage('assets/image/image_my.jpeg'),
                width: 200,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                '$t',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '<< See More Detail >>',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                _launchURL();
              },
              child: Image(
                image: AssetImage('assets/icon/link.png'),
                width: 100,
                height: 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
