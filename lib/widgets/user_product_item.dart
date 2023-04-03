import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/product.dart';

import '../screens/edit__product_screen.dart';
import '../Providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageURL;

  UserProductItem(this.id, this.imageURL, this.title);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Colors.black38,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Delete Failed haaaa',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
