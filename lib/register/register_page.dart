import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleflutter/edit_book/edit_book_model.dart';
import 'package:sampleflutter/register/register_model.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('新規登録'),
        ),
        body: Center(
          child: Consumer<RegisterModel>(builder: (context, model, child) {
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
                            await model.signUp();
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
                        child: Text('登録する')),
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