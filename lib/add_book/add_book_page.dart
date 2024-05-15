import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sampleflutter/add_book/add_book_model.dart';
import 'package:sampleflutter/book_list/book_list_model.dart';
import 'package:sampleflutter/domain/book.dart';

class AddBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('本を追加'),
        ),
        body: Center(
          child: Consumer<AddBookModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    GestureDetector(
                      child: SizedBox(
                        width: 100,
                        height: 160,
                        child: model.imageFile != null
                            ? Image.file(model.imageFile!)
                            : Container(
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () async {
                        print('反応!');
                        await model.pickImage();
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: '本のタイトル'
                      ),
                      onChanged: (text) {
                        model.title = text;
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: '本の著者'
                      ),
                      onChanged: (text) {
                        model.author = text;
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(onPressed: () async {
                      try {
                        model.startLoading();
                        await model.addBook();
                        Navigator.of(context).pop(true);
                      } catch(e) {
                        final snacBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snacBar);
                      } finally {
                        model.endLoading();
                      }
                    }, child: Text('追加する')),
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