import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../models/place.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = '/category-meals';
  final List docid = [];

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final categorylocal = routeArgs['local'];

    return Scaffold(
      appBar: AppBar(
        title: Text(categorylocal as String),
      ),
      body: Consumer<DataProvider>(
        builder: (context, model, child) {
          List models = model.placeModel
              .where((element) => element.local == categorylocal)
              .toList();
          return ListView.builder(
            itemBuilder: (context, index) {
              final place = models[index];
              return Place(
                id: place.id,
                local: place.local,
                name: place.name,
                url: place.url,
                done: place.done,
                docid: place.docid,
              );
            },
            itemCount: models.length,
          );
        },
      ),
    );
  }
}
