// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, empty_catches, unnecessary_null_comparison
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice/actions/firestoreService.dart';
import 'package:practice/pages/delivery.dart';
// import 'package:practice/pages/inventory_pages/inventory_category.dart';
import 'package:snapshot/snapshot.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});
  
  @override
  State<Inventory> createState() => _InventoryState();
}

// TextEditingController searchController = TextEditingController();
// TextEditingController searchAvailable = TextEditingController();

final TextEditingController pname = TextEditingController();
final TextEditingController pdescription = TextEditingController();
final TextEditingController pquan = TextEditingController();
final TextEditingController psellingprice = TextEditingController();
final TextEditingController punitcost = TextEditingController();
final TextEditingController pcat = TextEditingController();
final TextEditingController psupplier = TextEditingController();
final TextEditingController ppricelevel1 = TextEditingController();
final TextEditingController ppricelevel2 = TextEditingController();


class _InventoryState extends State<Inventory> {
  // final database = FirebaseDatabase.instance.reference();
  // late StreamSubscription productstream;

// @override
// void initState(){
//   super.initState();
//   // activateListener();
// }

// CollectionReference ref = FirebaseFirestore.instance.collection('products');
// final firestore = FirebaseFirestore.instance.collection('products').snapshots();

final FirestoreService firestoreService = FirestoreService();

var collection = FirebaseFirestore.instance.collection('products');
late List<Map<String, dynamic>> items ;
bool isLoaded = false;

// _incrementCounter()async{
//   List<Map<String, dynamic>> tempList = [];
//   var data = await collection.get();

//   data.docs.forEach((element) {
//     tempList.add(element.data());
//   });

//   setState(() {
//     items = tempList;
//     isLoaded = true;
//   });
// }

  String name = 'ALL ITEMS', search = '', searchAv = '', imageURL = '';
  bool nameOrCat = true, descTOF = true;

  @override
  Widget build(BuildContext context) {
    // _incrementCounter();
    // final dailySpecialRef = database.child('/Product');

    // void action(String? docID){
    //   showDialog(
    //     context: context, 
    //     builder: (context) {
    //       return Dialog(
    //         insetPadding: EdgeInsets.all(150),
    //         child: Container(
    //           child: Column(
    //             // mainAxisAlignment: MainAxisAlignment.center,
    //             children: [                 
    //               Container(
    //                 padding: EdgeInsets.only(top: 50),
    //                 width: 400,
    //                 alignment: Alignment.center,
    //                 child: Text("ADD ITEM"),
    //               ),
    //               Container(
    //                 width: 800,
    //                 child: Row(
    //                   children: [
    //                     Container(
    //                       width: 400,
    //                       padding: EdgeInsets.only(left: 40, right: 40),
    //                       child: TextField(
    //                         controller: pname,
    //                         decoration: InputDecoration(helperText: "Product Name:")
    //                       )
    //                     ),
    //                     Container(
    //                       width: 400,
    //                       padding: EdgeInsets.only(left: 40, right: 40),
    //                       child: TextField(
    //                         controller: pdescription,
    //                         decoration: InputDecoration(helperText: "Description:")
    //                       )
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Container(
    //                 width: 800,
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   children: [
    //                     Container(
    //                       width: 250,
    //                       padding: EdgeInsets.only(left: 30, right: 30),
    //                       child: TextField(
    //                         keyboardType: TextInputType.number,
    //                         inputFormatters: <TextInputFormatter>[
    //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    //                           FilteringTextInputFormatter.digitsOnly
    //                         ],
    //                         controller: pquan,
    //                         decoration: InputDecoration(helperText: "Quantity:")
    //                       )
    //                     ),
    //                     Container(
    //                       width: 250,
    //                       padding: EdgeInsets.only(left: 30, right: 30),
    //                       child: TextField(
    //                         keyboardType: TextInputType.numberWithOptions(decimal: true),
    //                         inputFormatters: <TextInputFormatter>[
    //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    //                         ],
    //                         controller: psellingprice,
    //                         decoration: InputDecoration(helperText: "Selling Price:"),
    //                       ),
    //                     ),
    //                     Container(
    //                       width: 250,
    //                       padding: EdgeInsets.only(left: 30, right: 30),
    //                       child: TextField(
    //                         keyboardType: TextInputType.numberWithOptions(decimal: true),
    //                         inputFormatters: <TextInputFormatter>[
    //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    //                         ],
    //                         controller: punitcost,
    //                         decoration: InputDecoration(helperText: "Unit Cost:"),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),          
    //               Container(
    //                 width: 800,
    //                 child: Row(
    //                   children: [
    //                     Container(
    //                       width: 400,
    //                       padding: EdgeInsets.only(left: 40, right: 40),
    //                       child: TextField(
    //                         controller: pcat,
    //                         decoration: InputDecoration(helperText: "Category:")
    //                       )
    //                     ),
    //                     Container(
    //                       width: 400,
    //                       padding: EdgeInsets.only(left: 40, right: 40),
    //                       child: TextField(
    //                         controller: psupplier,
    //                         decoration: InputDecoration(helperText: "Supplier:")
    //                       )
    //                     ),
    //                   ],
    //                 ),
    //               ),                 
    //               Container(
    //                 width: 800,
    //                 child: Row(
    //                   children: [
    //                     Container(
    //                       width: 400,
    //                       padding: EdgeInsets.only(left: 40, right: 40),
    //                       child: TextField(
    //                         keyboardType: TextInputType.numberWithOptions(decimal: true),
    //                         inputFormatters: <TextInputFormatter>[
    //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    //                         ],
    //                         controller: ppricelevel1,
    //                         decoration: InputDecoration(helperText: "Price Level 1:"),
    //                       ),
    //                     ),
    //                     Container(
    //                       width: 400,
    //                       padding: EdgeInsets.only(left: 40, right: 40),
    //                       child: TextField(
    //                         keyboardType: TextInputType.numberWithOptions(decimal: true),
    //                         inputFormatters: <TextInputFormatter>[
    //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    //                         ],
    //                         controller: ppricelevel2,
    //                         decoration: InputDecoration(helperText: "Price Level 2:"),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),           
    //               //bago to
    //               IconButton(
    //                 onPressed: () async {
    //                   ImagePicker imagePicker = ImagePicker();
    //                   XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    //                   if (file == null) {
    //                     return;
    //                   }
    //                   String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    //                   Reference referenceRoot = FirebaseStorage.instance.ref();
    //                   Reference referenceDirImages = referenceRoot.child('images');
    //                   Reference referenceImageToUpload = referenceDirImages.child(uniqueName);
    //                   try {
    //                     final bytes = await file.readAsBytes();
    //                     await referenceImageToUpload.putData(bytes);
    //                     String imageURL = await referenceImageToUpload.getDownloadURL();
    //                     setState(() {
    //                       this.imageURL = imageURL;
    //                     });
    //                   } catch (e) {
    //                     print(e);
    //                   }
    //                 },
    //                 icon: Icon(Icons.camera_alt),
    //               ),
    //               // imageURL != null ? Image.network(imageURL!) : Container(),
    //               Container(
    //                 child: ElevatedButton(
    //                   onPressed: () {
    //                     if (pname.text.isEmpty || pcat.text.isEmpty || pquan.text.isEmpty || psellingprice.text.isEmpty) {
    //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the fields!')));
    //                       return;
    //                     }                    
    //                     if (imageURL.isEmpty) {
    //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please upload image!')));
    //                       return;
    //                     }
    //                     if (docID == null) {
    //                       // firestoreService.addProduct(pname.text.toUpperCase(), pdescription.text.toUpperCase(), int.parse(pquan.text), double.parse(psellingprice.text), double.parse(punitcost.text), pcat.text.toUpperCase(), psupplier.text.toUpperCase(), int.parse(ppricelevel1.text), int.parse(ppricelevel2.text), imageURL);
    //                     } else {
    //                       firestoreService.updateProduct(docID, pname.text.toUpperCase(), pquan.text, pcat.text.toUpperCase(), psellingprice.text, imageURL);
    //                     }   
    //                     pname.clear();
    //                     pquan.clear();
    //                     pcat.clear();
    //                     psellingprice.clear();
    //                     Navigator.pop(context);
    //                   },
    //                   child: Text("SAVE")),
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        // title: Text("Inventory"),
        backgroundColor: Colors.blue[500],
      ),
      // drawer: Sidebar(),
      body: Container(
        color: Colors.blue[300],
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 15),
                        color: Colors.blue[300],
                        alignment: Alignment.centerLeft,
                        height: 60,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("Inventory", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
                        ),
                      ),
                      Container(
                        color: Colors.blue[300],
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20, bottom: 20),
                        height: 50,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("List of medicines available for sales.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 400,
                  height: 40,
                  margin: EdgeInsets.only(right: 30),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search...",
                    ),
                    onChanged: (val) {
                      setState(() {
                        search = val.toUpperCase();
                      });
                    },
                  ),
                ),
                Container(
                  color: Colors.blue[300],
                  margin: EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      pname.text = '';
                      pcat.text = '';
                      psellingprice.text = '';
                      pquan.text = '';
                      punitcost.text = '';
                      pdescription.text = '';
                      ppricelevel1.text = '';
                      ppricelevel2.text = '';
                      psupplier.text = '';
                      // action(null);
                      showDialog(
                        context: context, builder: (context) => StatefulBuilder(
                          builder: (context, setState) {
                            return Dialog(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Available Products", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  Container(
                                    width: 400,
                                    height: 40,
                                    margin: EdgeInsets.only(right: 30),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search),
                                        hintText: "Search...",
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          searchAv = val.toUpperCase();
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Container(
                                      margin: EdgeInsets.only(left: 30),
                                      child: Row(
                                        children: [
                                          Expanded(flex: 2, child: Text('Product Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                          Expanded(flex: 2, child: Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                          Expanded(child: Text('Qty', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                          Expanded(child: Text('Selling Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                          Expanded(child: Text('Unit Cost', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                          Expanded(flex: 2, child: Text('Category', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                          Expanded(flex: 2, child: Text('Suppplier', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                          Expanded(child: Text('Price Level 1', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                          Expanded(child: Text('Price Level 2', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                        ],
                                      ),
                                    ),
                                    trailing: Text('Actions'),
                                    leading: Text('Image')
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: firestoreService.getOrderStream(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List productList = snapshot.data!.docs;
                                    
                                          return ListView.builder(
                                            itemCount: productList.length,
                                            itemBuilder: (context, index) {
                                              DocumentSnapshot document = productList[index];
                                              String docID = document.id;
                                    
                                              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                              if (data != null) {
                                                // Use type annotations for clarity and safety
                                                int batchNumber = data['batch number'] as int? ?? 0;
                                                int barcodeID = data['barcode id'] as int? ?? 0;
                                                String productName = data['name'] as String? ?? "";
                                                String description = data['description'] as String? ?? "";
                                                int productQuantity = data['quantity'] as int? ?? 0;
                                                String category = data['category'] as String? ?? "";
                                                String supplier = data['supplier'] as String? ?? "";
                                                double sellingPrice = (data['selling price'] ?? 0.0) as double;
                                                double unitCost = (data['unit cost'] ?? 0.0) as double;
                                                String productImage = data['imageURL'] as String? ?? "";
                                                int priceLevel1 = data['price level 1'] as int? ?? 0;
                                                int priceLevel2 = data['price level 2'] as int? ?? 0;
                                                String img = data['imageURL'];
                                                Timestamp expirationDateTimestamp = data['expiration date'];
                                                Timestamp dateReceivedTimestamp = data['date received'];

                                                DateTime dateReceived = dateReceivedTimestamp.toDate();
                                                DateTime expirationDate = expirationDateTimestamp.toDate();
                                    
                                                // Now you can use these variables as needed.
                                    
                                                // if (data['status'] == 'STORED') {
                                                //   return ListTile(
                                                //     title: Row(
                                                //       children: [
                                                //         Expanded(flex: 2, child: Text(productName)),
                                                //         Expanded(flex: 2, child: Text(description)),
                                                //         Expanded(child: Text(productQuantity.toString())),
                                                //         Expanded(child: Text(sellingPrice.toString())),
                                                //         Expanded(child: Text(unitCost.toString())),
                                                //         Expanded(flex: 2, child: Text(category)),
                                                //         Expanded(flex: 2, child: Text(supplier)),
                                                //         Expanded(child: Text(priceLevel1.toString())),
                                                //         Expanded(child: Text(priceLevel2.toString())),
                                                //       ],
                                                //     ),
                                                //     trailing: Wrap(
                                                //       children: <Widget>[
                                                //         IconButton(onPressed: (){
                                                //           firestoreService.addToInventory(batchNumber, barcodeID, productName, description, productQuantity, sellingPrice, unitCost, category, supplier, priceLevel1, priceLevel2, img, expirationDate, dateReceived);
                                                //           firestoreService.updateStatus(docID, 'DISPLAYED');
                                                //           showDialog(
                                                //             context: context, 
                                                //             builder: (context) {
                                                //               return Dialog(
                                                //                 child: Padding(
                                                //                   padding: EdgeInsets.all(10.0),
                                                //                   child: Column(
                                                //                     mainAxisSize: MainAxisSize.min,
                                                //                     children: [
                                                //                       Container(
                                                //                         padding: EdgeInsets.all(5),
                                                //                         child: Text("PRODUCT DISPLAYED!"),
                                                //                       ),
                                                //                       Container(
                                                //                         child: TextButton(onPressed: (){
                                                //                           Navigator.pop(context);
                                                //                         }, 
                                                //                       child: Text("OK")),
                                                //                       )
                                                //                     ],
                                                //                   ),
                                                //                 ),
                                                //               );
                                                //             },
                                                //           );
                                                //         }, icon: Icon(Icons.add, color: Colors.black)),
                                                //       ],
                                                //     ),
                                                //     leading: Container(
                                                //       margin: EdgeInsets.only(right: 20),
                                                //       width: 50,
                                                //       height: 50,
                                                //       child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),
                                                //     ),
                                                //   );
                                                // }
                                                 
                                                if (data['status'] == 'STORED' && data['name'].toString().startsWith(searchAv)) {
                                                  return ListTile(
                                                    title: Row(
                                                      children: [
                                                        Expanded(flex: 2, child: Text(productName)),
                                                        Expanded(flex: 2, child: Text(description)),
                                                        Expanded(child: Text(productQuantity.toString())),
                                                        Expanded(child: Text(sellingPrice.toString())),
                                                        Expanded(child: Text(unitCost.toString())),
                                                        Expanded(flex: 2, child: Text(category)),
                                                        Expanded(flex: 2, child: Text(supplier)),
                                                        Expanded(child: Text(priceLevel1.toString())),
                                                        Expanded(child: Text(priceLevel2.toString())),
                                                      ],
                                                    ),
                                                    trailing: Wrap(
                                                      children: <Widget>[
                                                        IconButton(onPressed: (){
                                                          firestoreService.addToInventory(batchNumber, barcodeID, productName, description, productQuantity, sellingPrice, unitCost, category, supplier, priceLevel1, priceLevel2, img, expirationDate, dateReceived);
                                                          firestoreService.updateStatus(docID, 'DISPLAYED');
                                                          showDialog(
                                                            context: context, 
                                                            builder: (context) {
                                                              return Dialog(
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(10.0),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Container(
                                                                        padding: EdgeInsets.all(5),
                                                                        child: Text("PRODUCT DISPLAYED!"),
                                                                      ),
                                                                      Container(
                                                                        child: TextButton(onPressed: (){
                                                                          Navigator.pop(context);
                                                                        }, 
                                                                      child: Text("OK")),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }, icon: Icon(Icons.add, color: Colors.black)),
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
                                    
                                                //DISPLAY SEARCH 
                                                // if (data['status'] == 'STORED') {
                                                //   return ListTile(
                                                //     title: Row(
                                                //       children: [
                                                //         Expanded(flex: 5, child: Text(productName)),
                                                //         Expanded(flex: 5, child: Text(category)),
                                                //         Expanded(child: Text(sellingPrice.toString())),
                                                //         Expanded(child: Text(productQuantity.toString())),
                                                //       ],
                                                //     ),
                                                //     trailing: Wrap(
                                                //       children: <Widget>[
                                                //         IconButton(onPressed: (){
                                                //           pname.text = productName;
                                                //           pcat.text = category;
                                                //           psellingprice.text = sellingPrice.toString();
                                                //           pquan.text = productQuantity.toString();
                                                //           // action(docID);
                                                //         }, icon: Icon(Icons.edit, color: Colors.green)),
                                                //         IconButton(onPressed: (){
                                                //           firestoreService.deleteProduct(docID);
                                                //         }, icon: Icon(Icons.delete, color: Colors.red))
                                                //       ],
                                                //     ),
                                                //     leading: Container(
                                                //       margin: EdgeInsets.only(right: 20),
                                                //       width: 50,
                                                //       height: 50,
                                                //       child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),
                                                //     ),
                                                //   );
                                                // }
                                                return Container();
                                                } else {
                                                  // Handle case where data is null, depending on your application logic.
                                                }             
                                    
                                                //DEFAULT DISPLAY
                                                          
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
          
                                    
                                ],
                              )
                            ),
                          );
                          },
                          
                        )
                      );
                    },
                    child: Text('Add Item'),
                  ),
                )
              ],
            ),
            Container(
              color: Colors.white,
              height: 15,
            ),
            ListTile(
              title: Container(
                margin: EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text('Product Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Qty', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Selling Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Unit Cost', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('Category', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('Suppplier', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Price Level 1', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Price Level 2', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              trailing: Text('Actions'),
              leading: Text('Image')
            ),
            
            //ITEM DISPLAY CONTAINER
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.white,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getProductStream(nameOrCat, descTOF),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List productList = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = productList[index];
                          String docID = document.id;

                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          if (data != null) {
                            // Use type annotations for clarity and safety
                            String productName = data['name'] as String? ?? "";
                            String description = data['description'] as String? ?? "";
                            int productQuantity = data['quantity'] as int? ?? 0;
                            String category = data['category'] as String? ?? "";
                            String supplier = data['supplier'] as String? ?? "";
                            double sellingPrice = (data['selling price'] ?? 0.0) as double;
                            double unitCost = (data['unit cost'] ?? 0.0) as double;
                            String productImage = data['imageURL'] as String? ?? "";
                            int priceLevel1 = data['price level 1'] as int? ?? 0;
                            int priceLevel2 = data['price level 2'] as int? ?? 0;

                            // Now you can use these variables as needed.

                            if (name == 'ALL ITEMS' && search.isEmpty) {
                              return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(productName)),
                                    Expanded(flex: 2, child: Text(description)),
                                    Expanded(child: Text(productQuantity.toString())),
                                    Expanded(child: Text(sellingPrice.toString())),
                                    Expanded(child: Text(unitCost.toString())),
                                    Expanded(flex: 2, child: Text(category)),
                                    Expanded(flex: 2, child: Text(supplier)),
                                    Expanded(child: Text(priceLevel1.toString())),
                                    Expanded(child: Text(priceLevel2.toString())),                                    
                                  ],
                                ),
                                trailing: Wrap(
                                  children: <Widget>[
                                    IconButton(onPressed: (){
                                      // action(docID);
                                    }, icon: Icon(Icons.edit, color: Colors.green)),
                                    IconButton(onPressed: (){
                                      firestoreService.deleteProduct(docID);
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

                            //DISPLAY SEARCH 
                            if ((data['name'].toString().startsWith(search) && data['category'].toString().startsWith(category)) || (name == 'ALL ITEMS' && data['name'].toString().startsWith(search) || name == 'ALL ITEMS' && data['category'].toString().startsWith(search))) {
                              return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(productName)),
                                    Expanded(flex: 2, child: Text(description)),
                                    Expanded(child: Text(productQuantity.toString())),
                                    Expanded(child: Text(sellingPrice.toString())),
                                    Expanded(child: Text(unitCost.toString())),
                                    Expanded(flex: 2, child: Text(category)),
                                    Expanded(flex: 2, child: Text(supplier)),
                                    Expanded(child: Text(priceLevel1.toString())),
                                    Expanded(child: Text(priceLevel2.toString())), 
                                  ],
                                ),
                                trailing: Wrap(
                                  children: <Widget>[
                                    IconButton(onPressed: (){
                                      pname.text = productName;
                                      pcat.text = category;
                                      psellingprice.text = sellingPrice.toString();
                                      pquan.text = productQuantity.toString();
                                      // action(docID);
                                    }, icon: Icon(Icons.edit, color: Colors.green)),
                                    IconButton(onPressed: (){
                                      firestoreService.deleteProduct(docID);
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
                            } else {
                              // Handle case where data is null, depending on your application logic.
                            }             

                            //DEFAULT DISPLAY
                                      
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
              ),
            )
          ],
        ),
      )
    );
  }
}
