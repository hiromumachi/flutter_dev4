import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/data_provider.dart';
import '../screens/delete_comfirm_screen.dart';

class Place extends StatefulWidget {
  final int id;
  final String local;
  final String url;
  final bool done;
  final String name;
  final String docid;

  const Place(
      {required this.id,
      required this.local,
      required this.url,
      required this.done,
      required this.name,
      required this.docid});

  @override
  PlaceScreen createState() => PlaceScreen(
        id: id,
        local: local,
        url: url,
        done: done,
        name: name,
        docid: docid,
      );
}

class PlaceScreen extends State<Place> {
  int id;
  String local;
  String url;
  bool done;
  String name;
  String docid;

  PlaceScreen(
      {required this.id,
      required this.local,
      required this.url,
      required this.done,
      required this.name,
      required this.docid});

  void jumpUrl() {
    //somethig

    launchUrl(Uri.parse(url));
  }

  void add(bool? value) {
    FirebaseFirestore.instance
        .collection('place')
        .doc(docid)
        .update({'done': value});
    setState(() {
      done = value!;
    });
  }

  void delete(direction) async {
    FirebaseFirestore.instance.collection('place').doc(docid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: ((context, model, child) {
      return InkWell(
          onTap: () => jumpUrl(),
          child: Dismissible(
            key: Key(name),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              setState(() {
                model.deleteData(docid, id);
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      // （2） 実際に表示するページ(ウィジェット)を指定する
                      builder: (context) => deleteComfirmScreen()));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(name),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: done,
                              onChanged: (bool? value) {
                                add(value);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    }));
  }
}
