import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleflutter/login/login_model.dart';
import 'package:sampleflutter/register/register_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('ログイン'),
        ),
        body: Center(
          child: Consumer<LoginModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    TextField(
                      controller: model.titleController,
                      decoration: InputDecoration(
                          hintText: 'メールアドレス'
                      ),
                      onChanged: (text) {
                        model.setEmail(text);
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: model.authorController,
                      decoration: InputDecoration(
                          hintText: 'パスワード'
                      ),
                      onChanged: (text) {
                        model.setPassword(text);
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                        onPressed:() async {
                          model.startLoading();
                          try {
                            await model.login();
                            Navigator.of(context).pop();
                          } catch(e) {
                            final snacBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snacBar);
                          } finally {
                            model.endLoading();
                          }
                        },
                        child: Text('ログイン')),
                    TextButton(
                        onPressed:() async {
                          final String? title = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: Text('新規作成の方はこちら')),
                  ],),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black38,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            );
          }),
        ),
      ),
    );
  }
}