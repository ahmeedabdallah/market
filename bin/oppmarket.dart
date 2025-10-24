import 'dart:io';
// 1
void main() {
  Maket market = Maket();

  while (true) {
    print('''
Welcome to market
Press 1 to add new product
Press 2 to show all products
Press 3 to update product quantity
Press 4 to buy products
Press 5 to show all invoices
Press 6 to exit
''');

    int input = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    switch (input) {
      case 1:
        market.addpro();
        break;
      case 2:
        market.show();
        break;
      case 3:
        market.updatequantity();
        break;
      case 4:
        market.buyProducts();
        break;
      case 5:
        market.showInvoices();
        break;
      case 6:
        print('Thank you, see you later');
        exit(0);
      default:
        print('Wrong choice, try again.');
    }
  }
}

//---------------------- Product CLASS ----------------------
class Product {
  String namepro;
  int quantity;
  double price;
  int id;

  Product(this.id, this.namepro, this.quantity, this.price);

  void showinfo() =>
      print('id: $id | name: $namepro | quantity: $quantity | price: $price');

  void updatepro(int newQty) => quantity = newQty;

  @override
  String toString() {
    return 'id: $id | name: $namepro | quantity: $quantity | price: $price';
  }
}

//---------------------- Market CLASS ----------------------
class Maket {
  List<Product> products = [];
  List<Map<String, dynamic>> invoices = [];
  int counter = 1;

  void addpro() {
    print('Please enter product name:');
    String nameProduct = stdin.readLineSync() ?? '';

    print('Please enter product quantity:');
    int quantityProduct = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    print('Please enter product price:');
    double priceProduct = double.tryParse(stdin.readLineSync() ?? '') ?? 0;

    int id = products.length + 1;
    products.add(Product(id, nameProduct, quantityProduct, priceProduct));
    print('✅ Product added successfully!\n');
  }

  void show() {
    if (products.isEmpty) {
      print('❌ No products available yet.');
      return;
    }
    print('📦 Products List:');
    for (var i in products) {
      print(i);
    }
  }

  void updatequantity() {
    show();
    print('Please enter product name or id (0 to exit):');
    String input = stdin.readLineSync() ?? '';
    if (input == '0') return;

    Product? found;
    for (var p in products) {
      if (p.namepro == input || p.id == int.tryParse(input)) {
        found = p;
        break;
      }
    }

    if (found == null) {
      print('❌ Product not found.');
      return;
    }

    print('Enter new quantity:');
    int newQty = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
    if (newQty < 0) {
      print('❌ Invalid quantity.');
      return;
    }

    found.updatepro(newQty);
    print('✅ Quantity updated successfully!');
  }

  void buyProducts() {
    if (products.isEmpty) {
      print('❌ No products available to buy.');
      return;
    }

    show();
    print('Please enter your name:');
    String name = stdin.readLineSync() ?? '';

    List<Map<String, dynamic>> cart = [];

    while (true) {
      print("Enter product name or id (or 'done' to finish):");
      String input = stdin.readLineSync() ?? '';
      if (input.toLowerCase() == 'done') break;

      Product? found;
      for (var p in products) {
        if (p.namepro == input || p.id == int.tryParse(input)) {
          found = p;
          break;
        }
      }

      if (found == null) {
        print('❌ Product not found.');
        continue;
      }

      print('Enter quantity to buy:');
      int qty = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

      if (qty <= 0 || qty > found.quantity) {
        print('Invalid or insufficient quantity.');
        continue;
      }

      found.quantity -= qty;
      double total = qty * found.price;
      cart.add({
        'name': found.namepro,
        'qty': qty,
        'price': found.price,
        'total': total,
      });

      print('🛒 Added $qty x ${found.namepro} = $total');
    }

    if (cart.isEmpty) {
      print('No items purchased.');
      return;
    }

    double finalTotal = cart.fold(0, (sum, item) => sum + item['total']);

    invoices.add({
      'Invoice #$counter': {
        'Customer': name,
        'Items': cart,
        'Final Total': finalTotal,
      }
    });
    print('✅ Invoice saved successfully! Total = $finalTotal\n');
    counter++;
  }

  void showInvoices() {
    if (invoices.isEmpty) {
      print('🧾 No invoices yet.');
      return;
    }

    for (var inv in invoices) {
      inv.forEach((key, value) {
        print('\n$key');
        print('Customer: ${value['Customer']}');
        print('Items:');
        for (var item in value['Items']) {
          print('- ${item['name']} x${item['qty']} = ${item['total']}');
        }
        print('Total = ${value['Final Total']}');
      });
    }
  }
}
