import 'package:flutter_test/flutter_test.dart';
import 'package:testing/model/favourite.dart';

void main() {
  group("Testing app provider", () {
    var favourites = Favorites();
    test("A new item should be added", () {
      var number = 35;
      favourites.add(number);
      expect(favourites.items.contains(number), true);
      favourites.remove(number);
      expect(favourites.items.contains(number), false);
    });

    test("current index should be increment", () {
      final _cIndex = favourites.currentIndex;
      favourites.increment();
      expect(_cIndex < favourites.currentIndex, true);

      favourites.decrement();
      if (_cIndex > 0) {
        expect(_cIndex > favourites.currentIndex, true);
      }
    });
  });
}
