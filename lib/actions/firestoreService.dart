import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  final CollectionReference product = FirebaseFirestore.instance.collection('products');
  final CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  final CollectionReference receive = FirebaseFirestore.instance.collection('receive');
  final CollectionReference receivedOrders = FirebaseFirestore.instance.collection('receivedOrders');

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

  Future<void> quantityDeduction(String docID, String quantity){
    return product.doc(docID).update({
      'quantity': quantity,
    });
  }

    Future<void> addToInventory(int batchNumber, int barcodeid, String pname, String pdescription, int pquan, double psellingprice, double punitcost, String pcat, String psupplier, int plevel1, int plevel2, String imageURL, DateTime expirationDate, DateTime dateReceived){
    return product.add({
      'batch number': batchNumber,
      'barcode id' : barcodeid,
      'name': pname,
      'description': pdescription,
      'quantity': pquan,
      'selling price': psellingprice,
      'unit cost': punitcost,
      'category': pcat,
      'supplier': psupplier,
      'price level 1': plevel1,
      'price level 2': plevel2,
      'imageURL': imageURL,
      'expiration date': expirationDate,
      'date received': dateReceived,
    });
  }

  //UPDATE STATUS
  Future<void> updateStatus(String docID, String status){
    return receive.doc(docID).update({
      'status': status,
    });
  }

  //Display Order
  Stream<QuerySnapshot> getOrderStream(){
    return receive.orderBy('name', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getOrdersStream(){
    return receivedOrders.orderBy('date received', descending: true).snapshots();
  }

    Future<void> receiveProduct(int batchNumber, int barcodeid, String pname, String pdescription, int pquan, double psellingprice, double punitcost, String pcat, String psupplier, int plevel1, int plevel2, String imageURL, DateTime expirationDate, DateTime dateReceived, String status){
    return receive.add({
      'batch number': batchNumber,
      'barcode id' : barcodeid,
      'name': pname,
      'description': pdescription,
      'quantity': pquan,
      'selling price': psellingprice,
      'unit cost': punitcost,
      'category': pcat,
      'supplier': psupplier,
      'price level 1': plevel1,
      'price level 2': plevel2,
      'imageURL': imageURL,
      'expiration date': expirationDate,
      'date received': dateReceived,
      'status': status
    });
  }
  Future<void> addReceivedOrders(int batchNumber, DateTime dateReceived){
    return receivedOrders.add({
      'batch number': batchNumber,
      'date received': dateReceived
    });
  }
}

