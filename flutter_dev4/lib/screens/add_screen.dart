import 'package:flutter/material.dart';
import 'package:flutter_dev4/models/category.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';

class AddScreen extends StatefulWidget {
  _Addfunction createState() => _Addfunction();
}

class _Addfunction extends State<AddScreen> {
  String selectLocal = "海外";
  final nameController = TextEditingController();
  final urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Consumer<DataProvider>(builder: (context, model, child) {
            late List Locallist = [];
            List<Category> localCategory = model.localModel;
            for (var i = 0; i < model.countlocal; i++) {
              Locallist.add(localCategory[i].local);
            }
            return Center(
                child: Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                      value: selectLocal,
                      items: Locallist.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem(
                          value: value.toString(),
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectLocal = value!;
                        });
                      }),
                  TextFormField(
                      decoration: InputDecoration(labelText: "行きたい場所"),
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      }),
                  TextFormField(
                    decoration: InputDecoration(labelText: "場所のURL"),
                    controller: urlController,
                    validator: (value) {
                      late bool _validURL = Uri.parse(value!).isAbsolute;
                      if (_validURL) {
                        return null;
                      } else if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return 'enter accessible URL';
                      }
                    },
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await model.addData(model.count + 1, selectLocal,
                              nameController, urlController);
                          Navigator.pushNamed(context, '/');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('登録に失敗しました')),
                          );
                        }
                      },
                      child: Text("add"))
                ],
              ),
            ));
          }),
        ),
      ),
    ));
  }
}
