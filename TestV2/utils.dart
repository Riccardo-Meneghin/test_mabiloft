import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:test_mabiloft/info.dart';
import 'package:image_picker/image_picker.dart';

final _chipstyle = TextStyle(
  color: Color(0xffee825e),
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
);
List<Info> info = <Info>[];

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xfff31a1d); //0xffe7262c
    Path path = Path()
      ..relativeLineTo(0, 30)
      ..quadraticBezierTo(size.width / 2, 65, size.width, 30)
      ..relativeLineTo(500, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PhotoEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  final picker = ImagePicker();
  File? imageFile;

  void chooseProPic(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 3.4,
            ),
            painter: HeaderCurvedContainer(),
          ),
          ClipOval(
            child: Material(
              color: Colors.grey,
              child: imageFile != null
                  ? Ink.image(
                      image: FileImage(imageFile!),
                      width: 110.0,
                      height: 110.0,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 110.0,
                      width: 110.0,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                      ),
                    ),
            ),
          ),
          Positioned(
            child: ClipOval(
              child: Material(
                color: Color(0xffeb683d),
                child: Ink(
                  width: 38.0,
                  height: 38.0,
                  child: IconButton(
                    icon: Icon(Icons.edit_outlined,
                        color: Colors.white, size: 24.0),
                    onPressed: () => chooseProPic(ImageSource.gallery),
                  ),
                ),
              ),
            ),
            bottom: 0.0,
            right: 150.0,
          ),
        ],
      ),
    );
  }
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
      leading: CupertinoNavigationBarBackButton(
        onPressed: () => (null),
        color: Colors.white,
      ),
      /*flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffde0a43), Color(0xfff04216)],
          ),
        ),
      ), Lascio indicato l'intento iniziale d'usare un gradient, nel painter non sono stato in grado d'applicarlo*/
      backgroundColor: Color(0xfff31a1d),
      elevation: 0.0,
      title: Text("Back"),
      titleSpacing: -15.0,
      actions: [
        RotatedBox(
          quarterTurns: 1,
          child: PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Null>>[],
            enabled: true,
            iconSize: 30.0,
          ),
        ),
      ]);
}

Container buildText() {
  return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Text(
            "Alessio Morale",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                letterSpacing: 0.9),
          ),
          Text(
            "123 Followers",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
        ],
      ));
}

Padding buildPadding(String text) {
  return Padding(
    padding: EdgeInsets.fromLTRB(5.0, 25.0, 0.0, 15.0),
    child: Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15.0),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
                color: Color(0xff626262)),
          ),
        ),
      ],
    ),
  );
}

Chip createChip(String text) {
  return Chip(
    label: Text(
      text,
      style: _chipstyle,
    ),
    labelPadding: EdgeInsets.all(7.0),
    backgroundColor: Color(0xfffce9e2),
  );
}

Container rowChips() {
  return Container(
    margin: EdgeInsets.only(left: 15.0),
    child: Wrap(spacing: 6.0, children: [
      createChip("Superheroes"),
      createChip("Crime"),
      createChip("Comedy"),
      createChip("Adventure"),
      createChip("Sci-Fi"),
    ]),
  );
}

SingleChildScrollView buildChips() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: rowChips(),
  );
}

Future<List<Info>> getMovies() async {
  final response =
      await http.get(Uri.https("jsonplaceholder.typicode.com", "photos"));
  final body = json.decode(response.body);

  return body.map<Info>(Info.fromJson).toList();
}

Widget buildCard(List<Info> info) {
  return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        final indexedInfo = info[index];
        return Container(
          margin: EdgeInsets.only(left: 15.0),
          child: Card(
            color: Color(0xfff1f1f9),
            elevation: 0.2,
            margin: EdgeInsets.only(right: 20.0, top: 8.0, bottom: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Wrap(
                        spacing: 15.0,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Material(
                              color: Colors.transparent,
                              child: Ink.image(
                                image: NetworkImage(indexedInfo.url),
                                width: 180.0,
                                height: 175.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 150.0,
                            height: 175.0,
                            alignment: Alignment.center,
                            child: Text(
                              indexedInfo.title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

buildJson() {
  return FutureBuilder<List<Info>>(
      future: getMovies(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return Center(child: Text("Errore nel caricamento dei dati"));
            else
              return buildCard(info!);
        }
      });
}
