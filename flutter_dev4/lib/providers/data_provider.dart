import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place_model.dart';
import '../models/category.dart';

class DataProvider extends ChangeNotifier {
  List<PlaceModel> _placeModel = [];
  List<Category> _localModel = [];
  List docid = [];
  var uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future fetchDataLocal() async {
    _placeModel.removeRange(0, _placeModel.length);
    final User? _currentUser = await firebaseAuth.currentUser;
    var _uid = _currentUser!.uid;

    var localDoc = await firestore.collection('locals').snapshots();
    var docs2 = await firestore.collection('place').snapshots();

    localDoc.forEach((doc) {
      doc.docs.forEach((data) {
        final localModel = Category(
          id: data.data()['id'],
          local: data.data()['local'],
          color: Color(data.data()['color']),
        );

        _localModel.add(localModel);
      });
    });

    docs2.forEach((doc) {
      doc.docs.forEach((data) {
        var placeModel = PlaceModel(
          id: data.data()['id'],
          local: data.data()['local'],
          done: data.data()['done'],
          name: data.data()['name'],
          url: data.data()['url'],
          docid: data.id,
        );
        _placeModel.add(placeModel);
      });
    });
    uid = _uid;

    notifyListeners();
  }

  Future addData(id, selectLocal, nameController, urlController) async {
    _placeModel.clear();
    FirebaseFirestore.instance.collection('place').add({
      'done': false,
      'id': id,
      'local': selectLocal,
      'name': nameController.text,
      'uid': uid,
      'url': urlController.text
    });
    notifyListeners();
  }

  void deleteData(docid, id) async {
    _placeModel.clear();

    FirebaseFirestore.instance.collection('place').doc(docid).delete();

    notifyListeners();
  }

  UnmodifiableListView<Category> get localModel {
    return UnmodifiableListView(_localModel);
  }

  UnmodifiableListView<PlaceModel> get placeModel {
    return UnmodifiableListView(_placeModel);
  }

  int get count {
    return _placeModel.length;
  }

  int get countlocal {
    return _localModel.length;
  }
}
