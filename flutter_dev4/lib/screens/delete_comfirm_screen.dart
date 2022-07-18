import 'package:flutter/material.dart';
import 'package:flutter_dev4/screens/tabs_screen.dart';

class deleteComfirmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "削除しました",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    // （2） 実際に表示するページ(ウィジェット)を指定する
                    builder: (context) => TabsScreen())),
            child: Text("戻る"),
          )
        ],
      ),
    ));
  }
}
