import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach(
      (key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      },
    );
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: DateTime.now().toString(),
          price: price,
          quantity: existingCartItem.quantity + 1,
          title: title,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productID) {
    _items.remove(productID);
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) {
      return;
    }
    if (_items[productID].quantity > 1) {
      _items.update(
        productID,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity - 1,
            title: existingCartItem.title),
      );
    } else {
      _items.remove(productID);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
