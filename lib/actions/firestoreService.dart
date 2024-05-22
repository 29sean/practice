import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  final CollectionReference product = FirebaseFirestore.instance.collection('products');
  final CollectionReference cart = FirebaseFirestore.instance.collection('cart');

  Future<void> updateProduct(String docID, String newPName, String newPQuan, String newCat, String newPrice, String newImageURL){
    return product.doc(docID).update({
      'name': newPName,
      'quantity': newPQuan,
      'category': newCat,
      'price': newPrice,
      'imageURL': newImageURL,
    });
  }

  Future<void> addProduct(String pname, String pquan, String pcat, String pprice, String imageURL){
    return product.add({
      'name': pname,
      'quantity': pquan,
      'category': pcat,
      'price': pprice,
      'imageURL': imageURL,
    });
  }
  //display to
  Stream<QuerySnapshot> getProductStream(bool nameOrCat ,bool descTOF){
    if (nameOrCat) {
      final productStream = product.orderBy('name', descending: descTOF).snapshots();

      return productStream;
    } else {
      final productStream = product.orderBy('category', descending: descTOF).snapshots();

      return productStream;
    }
    
  }
  

  Future<void> deleteProduct(String docID){
    return product.doc(docID).delete();
  }


  //ADD 2 CART
  Future<void> add2Cart(String name, int quantity, double total){
    return cart.add({
      'name': name,
      'quantity': quantity,
      'total': total
    });
  }

  //DISPLAY CART
  Stream<QuerySnapshot> getCartStream(){
    final cartStream = cart.snapshots();

    return cartStream;
  }
}

