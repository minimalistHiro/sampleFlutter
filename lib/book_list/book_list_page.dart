import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sampleflutter/add_book/add_book_page.dart';
import 'package:sampleflutter/book_list/book_list_model.dart';
import 'package:sampleflutter/domain/book.dart';
import 'package:sampleflutter/edit_book/edit_book_page.dart';
import 'package:sampleflutter/login/login_page.dart';

class BookListPage extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('本一覧'),
          actions: [
            IconButton(onPressed: () async {
              final String? title = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                  fullscreenDialog: true,
                ),
              );
            }, icon: Icon(Icons.person)),
          ],
        ),
        body: Center(
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;

            // 取得までインジケーターを表示
            if (books == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = books.map(
                  (book) => Slidable(
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) async {
                        // 編集画面に移動
                        final String? title = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBookPage(book),
                          ),
                        );

                        if (title != null) {
                          final snacBar = SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('$titleを編集しました'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snacBar);
                        }

                        model.fetchBookList();
                      },
                      backgroundColor: Colors.black45,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: '編集',
                    ),
                    SlidableAction(
                      onPressed: (_) async {
                        await CustomShowDialog(context, book, model);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: '削除',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  leading: book.imgURL != null ? Image.network(book.imgURL!) : null,
                ),
              ),
            ).toList();
            return ListView(children: widgets,);
          }),
        ),
        floatingActionButton: Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              // 追加画面に移動
              final bool? isAdded = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(),
                  fullscreenDialog: true,
                ),
              );

              if (isAdded != null && isAdded) {
                final snacBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('本を追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snacBar);
              }

              model.fetchBookList();
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        }
        ),
      ),
    );
  }

  Future<void> CustomShowDialog(BuildContext context, Book book, BookListModel model) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text('削除の確認'),
          content: Text('「${book.title}」を削除しますか？'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                await model.deleteBook(book);
                Navigator.pop(context);

                final snacBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('${book.title}を削除しました'),
                );
                model.fetchBookList();
                ScaffoldMessenger.of(context).showSnackBar(snacBar);
              },
            ),
          ],
        );
      },
    );
  }
}