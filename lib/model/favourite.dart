import 'package:flutter/material.dart';

class Favorites extends ChangeNotifier {
  final List<int> _favoriteItems = [];

  int currentIndex = 0;

  List<int> get items => _favoriteItems;

  void add(int itemNo) {
    _favoriteItems.add(itemNo);
    notifyListeners();
  }

  void remove(int itemNo) {
    _favoriteItems.remove(itemNo);
    notifyListeners();
  }

  void increment() {
    currentIndex = currentIndex + 1;
    notifyListeners();
  }

  void decrement() {
    if (currentIndex > 0) {
      currentIndex--;
    }
    notifyListeners();
  }
}
