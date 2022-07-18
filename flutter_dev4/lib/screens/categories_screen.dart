import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  final FirebaseFirestore Firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.collection('locals').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: const Text('Loading events...'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(25),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Material(
                color: Color(snapshot.data.docs[index]['color']),
                child: CategoryItem(
                  snapshot.data.docs[index]['id'],
                  snapshot.data.docs[index]['local'],
                  snapshot.data.docs[index]['color'],
                ),
                // Text(snapshot.data.docs[index]['local']),
              );
            },
            // .map(
            //   (catData) => CategoryItem(
            //     catData.id,
            //     catData.title,
            //     catData.color,
            //   ),
            // )
            // .toList(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
          );
        });
  }
}
