import 'package:flutter/material.dart';

import '../screens/category_screen.dart';
import '../providers/data_provider.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String local;
  final int color;

  CategoryItem(this.id, this.local, this.color);

  void selectCategory(BuildContext ctx) async {
    Navigator.of(ctx).pushNamed(
      CategoryScreen.routeName,
      arguments: {
        'id': id,
        'local': local,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          local,
          style: Theme.of(context).textTheme.headline6,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(color).withOpacity(0.7),
              Color(color),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
