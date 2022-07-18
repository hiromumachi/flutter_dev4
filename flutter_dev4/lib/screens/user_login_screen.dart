import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  _UserLogin createState() => _UserLogin();
}

class _UserLogin extends State<UserLoginScreen> {
  //ステップ１
  final _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';
  String infoText = '';

  void errorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // 認証フローのトリガー
    final googleUser = await GoogleSignIn(scopes: [
      'email',
    ]).signIn();
    // リクエストから、認証情報を取得
    final googleAuth = await googleUser!.authentication;
    // クレデンシャルを新しく作成
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // サインインしたら、UserCredentialを返す
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(
                hintText: 'メールアドレスを入力',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'パスワードを入力',
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('ログイン'),
            //ステップ２
            onPressed: () async {
              try {
                final newUser = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                if (newUser != null) {
                  Navigator.pushNamed(context, '/');
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-email') {
                  errorMessage('メールアドレスのフォーマットが正しくありません');
                } else if (e.code == 'user-disabled') {
                  errorMessage('現在指定したメールアドレスは使用できません');
                } else if (e.code == 'user-not-found') {
                  errorMessage('指定したメールアドレスは登録されていません');
                } else if (e.code == 'wrong-password') {
                  errorMessage('パスワードが間違っています');
                }
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // メール/パスワードでユーザー登録
                final FirebaseAuth auth = FirebaseAuth.instance;
                await auth.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                await Navigator.pushNamed(context, '/');
              } catch (e) {
                // ユーザー登録に失敗した場合
                errorMessage('登録に失敗しました');
              }
            },
            child: const Text('新規登録'),
          ),
          SizedBox(
              width: 90, //横幅
              height: 40, //高さ
              child: ElevatedButton(
                child: const Text('Google'),
                onPressed: () async {
                  try {
                    final userCredential = await signInWithGoogle();
                  } on FirebaseAuthException catch (e) {
                    errorMessage('登録に失敗しました');
                  } on Exception catch (e) {
                    errorMessage('登録に失敗しました');
                  }
                  await Navigator.pushNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, //ボタンの背景色
                    onPrimary: Colors.red),
              ))
        ],
      ),
    );
  }
}
