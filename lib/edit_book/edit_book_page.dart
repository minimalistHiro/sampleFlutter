import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleflutter/edit_book/edit_book_model.dart';
import '../domain/book.dart';

class EditBookPage extends StatelessWidget {
  final Book book;
  EditBookPage(this.book);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditBookModel>(
      create: (_) => EditBookModel(book),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('本を編集'),
        ),
        body: Center(
          child: Consumer<EditBookModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                TextField(
                  controller: model.titleController,
                  decoration: InputDecoration(
                      hintText: '本のタイトル'
                  ),
                  onChanged: (text) {
                    model.setTitle(text);
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: model.authorController,
                  decoration: InputDecoration(
                      hintText: '本の著者'
                  ),
                  onChanged: (text) {
                    model.setAuthor(text);
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    onPressed: model.isUpdaetd() ? () async {
                      try {
                        await model.updateBook();
                        Navigator.of(context).pop(model.title);
                      } catch(e) {
                        final snacBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snacBar);
                      }
                    } : null,
                    child: Text('更新する')),
              ],),
            );
          }),
        ),
      ),
    );
  }
}