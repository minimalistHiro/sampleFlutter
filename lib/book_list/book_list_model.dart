import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/domain/book.dart';

class BookListModel extends ChangeNotifier {
  List<Book>? books;

  void fetchBookList() async {
    final QuerySnapshot snapshot = await
    FirebaseFirestore.instance.collection('books').get();

    final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final String author = data['author'];
      final String? imgURL = data['imgURL'];
      return Book(id, title, author, imgURL);
    }).toList();

    this.books = books;
    notifyListeners();
  }

  Future<void> deleteBook(Book book) async {
    await FirebaseFirestore.instance.collection('books').doc(book.id).delete();
    await FirebaseStorage.instance.ref('books/${book.id}').delete();
  }
}
