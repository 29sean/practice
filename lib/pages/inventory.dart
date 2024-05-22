// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, empty_catches
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
import 'package:practice/inventory_page/inventory_category.dart';
import 'package:snapshot/snapshot.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});
  
  @override
  State<Inventory> createState() => _InventoryState();
}

TextEditingController searchController = TextEditingController();

final TextEditingController pname = TextEditingController();
final TextEditingController pquan = TextEditingController();
final TextEditingController pcat = TextEditingController();
final TextEditingController pprice = TextEditingController();

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

  String name = '$category', search = '', imageURL = '';
  bool nameOrCat = true, descTOF = true;

  @override
  Widget build(BuildContext context) {
    // _incrementCounter();
    // final dailySpecialRef = database.child('/Product');

    void action(String? docID){
      showDialog(
        context: context, 
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.all(50),
            child: Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    width: 400,
                    alignment: Alignment.center,
                    child: Text("ADD ITEM"),
                  ),
                  Container(
                    width: 400,
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextField(
                      controller: pname,
                      decoration: InputDecoration(helperText: "Product Name:")
                    )
                  ),
                  Container(
                    width: 400,
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextField(
                      controller: pcat,
                      decoration: InputDecoration(helperText: "Category:")
                    )
                  ),
                  Container(
                    width: 400,
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      controller: pprice,
                      decoration: InputDecoration(helperText: "Price:"),
                    ),
                  ),
                  Container(
                    width: 400,
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: pquan,
                      decoration: InputDecoration(helperText: "Quantity:")
                    )
                  ),
                  IconButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                      if (file == null) {
                        return;
                      }

                      String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages = referenceRoot.child('images');

                      Reference referenceImageToUpload = referenceDirImages.child(uniqueName);

                      try {
                        await referenceImageToUpload.putFile(File(file!.path));
                        imageURL = await referenceImageToUpload.getDownloadURL();
                      } catch (e) {
                        
                      }
                    }, 
                    icon: Icon(
                      Icons.camera_alt
                    )
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        if (pname.text.isEmpty || pcat.text.isEmpty || pquan.text.isEmpty || pprice.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the fields!')));
                          return;
                        }
                        
                        if (imageURL.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please upload image!')));
                          return;
                        }

                        if (docID == null) {
                          firestoreService.addProduct(pname.text.toUpperCase(), pquan.text, pcat.text.toUpperCase(), pprice.text, imageURL);
                        } else {
                          firestoreService.updateProduct(docID, pname.text.toUpperCase(), pquan.text, pcat.text.toUpperCase(), pprice.text, imageURL);
                        }   

                        pname.clear();
                        pquan.clear();
                        pcat.clear();
                        pprice.clear();
                        Navigator.pop(context);
                      },
                      child: Text("SAVE")),
                  )
                ],
              ),
            ),
          );
        },
      );
    }

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
                      action(null);
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

            //ROW HEADER
            Expanded(
              child: Container(
                color: Colors.blue,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 73, 73, 73)
                          )
                        ),
                        child: Center(
                          child: Text('Image', 
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 15
                            )
                          )
                        )
                      )
                    ),

                    //ITEM HEADER
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () {
                          nameOrCat = true;
                          setState(() {
                            if (nameOrCat) {
                              if (descTOF == false) {
                                firestoreService.getProductStream(nameOrCat == true, descTOF == false);
                                descTOF = true;
                              } else {
                                firestoreService.getProductStream(nameOrCat == true, descTOF == true);
                                descTOF = false;
                              }
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 73, 73, 73)
                            )
                          ),
                          child: Center(
                            child: Text('Product', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 15
                              )
                            )
                          )
                        )
                      )
                    ),

                    //CATEGORY HEADER
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () {
                          nameOrCat = false;
                          setState(() {
                            if (nameOrCat == false) {
                              if (descTOF == false) {
                                firestoreService.getProductStream(nameOrCat == false, descTOF == false);
                                descTOF = true;
                              } else {
                                firestoreService.getProductStream(nameOrCat == false, descTOF == true);
                                descTOF = false;
                              }
                            }
                          });
                        }, 
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 73, 73, 73)
                            )
                          ),
                          child: Center(
                            child: Text('Category', 
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 15
                            )
                            )
                          )
                        )
                      )
                    ),

                    //PRICE HEADER
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 73, 73, 73)
                          )
                        ),
                        child: Center(
                          child: Text('Price', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15)
                          )
                        )
                      )
                    ),
                    
                    //QUANTITY HEADER
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 73, 73, 73)
                          )
                        ),
                        child: Center(
                          child: Text('Quantity', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)
                          )
                        )
                      )
                    ),

                    //ACTION HEADER
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      width: 140,
                      // padding: EdgeInsets.only(right: 50),
                      alignment: Alignment.center,
                      child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                    ),
                  ],
                ),
              ),
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
                          String productName = data['name'];
                          String productQuantity = data['quantity'];
                          String productCategory = data['category'];
                          String productPrice = data['price'];
                          String productImage = data['imageURL'];             

                          //DEFAULT DISPLAY
                          if (name == 'ALL ITEMS' && search.isEmpty) {
                            return ListTile(
                              title: Row(
                                children: [
                                  Expanded(flex: 5, child: Text(productName)),
                                  Expanded(flex: 5, child: Text(productCategory)),
                                  Expanded(child: Center(child: Container(margin: EdgeInsets.only(right: 10), child: Text(productPrice)))),
                                  Expanded(child: Center(child: Container(margin: EdgeInsets.only(right: 10), child: Text(productQuantity)))),
                                ],
                              ),
                              trailing: Wrap(
                                children: <Widget>[
                                  IconButton(onPressed: (){
                                    action(docID);
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
                                  Expanded(flex: 5, child: Text(productName)),
                                  Expanded(flex: 5, child: Text(productCategory)),
                                  Expanded(child: Text(productPrice)),
                                  Expanded(child: Text(productQuantity)),
                                ],
                              ),
                              trailing: Wrap(
                                children: <Widget>[
                                  IconButton(onPressed: (){
                                    action(docID);
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



                // child: isLoaded?ListView.builder(
                //   itemCount: items.length,
                //   itemBuilder: (context, index) {
                //     return Padding(
                //       padding: EdgeInsets.all(8.0),
                //       child: ListTile(
                //         shape: RoundedRectangleBorder(
                //           side: BorderSide(width: 2),
                //           borderRadius: BorderRadius.circular(20)
                //         ),
                //         leading: CircleAvatar(
                //           backgroundColor: Color.fromARGB(255, 83, 211, 228),
                //           child: Icon(Icons.medical_services_rounded),
                //         ),
                //         title: Row(
                //           children: [
                //             Expanded(child: Text('Product Name : ' + items[index]['name'??'No data'])),
                //             Expanded(child: Text('Category : ' + items[index]['category'??"No data"])),
                //             Expanded(child: Text('Price : ' + items[index]['price'].toString())),
                //             Expanded(child: Text('Quantity : ' + items[index]['quantity'].toString())),
                //           ],
                //         ),
                //         trailing: Wrap(
                //           spacing: 10,
                //           children: <Widget>[
                //             IconButton(onPressed: (){
                              
                //             }, icon: Icon(Icons.edit, color: Colors.green)),
                //             IconButton(onPressed: (){

                //             }, icon: Icon(Icons.delete, color: Colors.red))
                //           ],
                //         ),
                //       ),
                //     );
                // })
                // :Text("")
              ),
            )
          ],
        ),
      )
    );
  }
  // @override
  // void deactivate(){
  //   // productstream.cancel();
  //   super.deactivate();
  // }

}
