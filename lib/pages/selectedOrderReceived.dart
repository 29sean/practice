// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practice/actions/firestoreService.dart';
import 'package:practice/pages/delivery.dart';

class selectedOrderReceived extends StatefulWidget {
  const selectedOrderReceived({super.key});

  @override
  State<selectedOrderReceived> createState() => _selectedOrderReceivedState();
}

class _selectedOrderReceivedState extends State<selectedOrderReceived> {

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                color: Colors.green,
                child: Text('Batch Number : ${selectedBatchNumber}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(flex: 2, child: Text('Product Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Qty', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Selling Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Unit Cost', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      Expanded(flex: 1, child: Text('Category', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      Expanded(flex: 1, child: Text('Suppplier', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Price Level 1', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Price Level 2', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Expiration Date', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Date Receive', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Status', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  // trailing: Expanded(child: Text('Status', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                  leading: Expanded(child: Text('Image', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                ),
              )
            ),
            Expanded(
              flex: 9,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                color: Colors.white,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getOrderStream(), 
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List ordersList = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: ordersList.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = ordersList[index];
                          String docID = document.id;

                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                          // String name = data['name'];
                          // int quantity = data['quantity'];
                          int batchNumber = data['batch number'];
                          // Timestamp expirationDateTimestamp= data['expiration date'];
                          String status = data['status'];

                          String productName = data['name'];
                          String description = data['description'];
                          int productQuantity = data['quantity'];
                          String category = data['category'];
                          String supplier = data['supplier'];
                          double sellingPrice = (data['selling price']);
                          double unitCost = (data['unit cost']);
                          String productImage = data['imageURL'];
                          int priceLevel1 = data['price level 1'];
                          int priceLevel2 = data['price level 2'];

                          Timestamp expirationDateTimestamp= data['expiration date'];
                          Timestamp dateReceivedTimestamp= data['date received'];

                          DateTime expirationDate = expirationDateTimestamp.toDate();
                          DateTime dateReceived = dateReceivedTimestamp.toDate();

                          if (batchNumber == selectedBatchNumber) {
                            return ListTile(
                            title: Row(
                              children: [
                                Expanded(flex: 2, child: Text(productName)),
                                Expanded(
                                  child: IconButton(onPressed: () {
                                    showDialog(
                                      context: context, 
                                      builder: (context) {
                                        return Dialog(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(description)),
                                              Container(
                                                padding: EdgeInsets.all(10.0),
                                                child: ElevatedButton(onPressed: (){
                                                  Navigator.pop(context);
                                                }, 
                                                child: Text('Back')),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }, 
                                  icon: Icon(Icons.more_horiz))
                                ),
                                Expanded(child: Text(productQuantity.toString())),
                                Expanded(child: Text(sellingPrice.toString())),
                                Expanded(child: Text(unitCost.toString())),
                                Expanded(flex: 2, child: Text(category)),
                                Expanded(flex: 2, child: Text(supplier)),
                                Expanded(child: Text(priceLevel1.toString())),
                                Expanded(child: Text(priceLevel2.toString())),
                                Expanded(flex: 2, child: Text(expirationDate.toString())),
                                Expanded(flex: 2, child: Text(dateReceived.toString())),
                                Expanded(child: Text(status, style: TextStyle(fontSize: 10))),
                              ],
                            ),
                            // trailing: Expanded(child: Text(status)),
                            trailing: Wrap(
                              children: <Widget>[
                                IconButton(onPressed: (){
                                  // action(docID);
                                }, icon: Icon(Icons.edit, color: Colors.green)),
                                IconButton(onPressed: (){
                                  // firestoreService.deleteProduct(docID);
                                }, icon: Icon(Icons.delete, color: Colors.red))
                              ],
                            ),
                            leading: Container(
                                margin: EdgeInsets.only(right: 20),
                                width: 50,
                                height: 50,
                                child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),
                              ),
                            );
                          }
                          return Container();
                        },
                      );
                    }
                    else {
                      return Expanded(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Text('No product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40))
                        ),
                      );
                    }
                  },
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}