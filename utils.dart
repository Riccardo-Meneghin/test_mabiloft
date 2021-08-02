import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_mabiloft/info.dart';
import 'package:image_picker/image_picker.dart';

final _chipstyle = TextStyle(
  color: Colors.red.shade900,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
);
List<Info> info = <Info>[];

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
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: imageFile != null
                    ? Ink.image(
                        image: FileImage(imageFile!),
                        width: 135.0,
                        height: 135.0,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 135.0,
                        width: 135.0,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                        ),
                      ),
              ),
            ),
          ),
          Positioned(
            child: ClipOval(
              child: Material(
                color: Colors.orange,
                child: Ink(
                  width: 45.0,
                  height: 45.0,
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => chooseProPic(ImageSource.gallery),
                    color: Colors.white70,
                    iconSize: 25.0,
                  ),
                ),
              ),
            ),
            bottom: 0.0,
            right: 1.0,
          ),
        ],
      ),
    );
  }
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
      leading: BackButton(),
      backgroundColor: Colors.redAccent,
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Null>>[],
          enabled: true,
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
          ),
          Text(
            "123 Followers",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
          ),
        ],
      ));
}

Padding buildPadding(String text) {
  return Padding(
    padding: EdgeInsets.fromLTRB(5.0, 35.0, 0.0, 15.0),
    child: Row(
      children: [
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17.0),
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
    backgroundColor: Colors.red.shade100,
  );
}

Wrap rowChips() {
  return Wrap(spacing: 6.0, children: [
    createChip("Superheroes"),
    createChip("Crime"),
    createChip("Comedy"),
    createChip("Adventure"),
    createChip("Sci-Fi"),
  ]);
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
      physics:  ScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        final indexedInfo = info[index];
        return Card(
          color: Colors.grey.shade200,
          elevation: 0.0,
          margin: EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0),),
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
                              width: 195.0,
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
