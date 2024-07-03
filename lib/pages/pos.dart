// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practice/actions/firestoreService.dart';
import 'package:practice/pages/inventory.dart';

class POS extends StatefulWidget {
  const POS({super.key});

  @override
  State<POS> createState() => _POSState();
}

class _POSState extends State<POS> {

  FirestoreService firestoreService = FirestoreService();

  String name = '', imageURL = '';
  bool nameOrCat = true, descTOF = true;
  int quantityCounter = 1, qtt = 0;
  double totalPriceQuantity = 0, totalAmount = 0;

  // List<List<dynamic>> cartItem = [];
  List cartProductNames = [];
  List cartProductQuantity = [];
  List cartProductPrice = [];
  List cartProductID = [];
  List cartProductQuantityData = [];

  void printcart() {
    for (int j = 0; j < cartProductNames.length; j++) {
      print(cartProductNames[j]);
    
  }
  }

  // void incrementQuantity() {
  //   setState(() {
  //     quantityCounter++;
  //   });
  // }

  void countAmount(){
    setState(() {
      totalAmount += totalPriceQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('MONTICASA DRUGSTORE'),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue[300],
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.green[300],
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text('POINT OF SALE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
                              )
                            ),
                            Expanded(
                              child: Container(
                                // color: Colors.amber[200],
                                child: TextField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    hintText: "Search...",
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                     name = val;
                                    });
                                  },
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.green[200],
                        child: StreamBuilder(
                          stream: firestoreService.getProductStream(nameOrCat, descTOF), 
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List productList = snapshot.data!.docs;

                              return GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                                itemCount: productList.length, 
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document = productList[index];
                                  String docID = document.id;

                                  Map<String, dynamic> data = document.data() as Map<String,dynamic>;

                                  String productName = data['name'];
                                  String productQuantity = data['quantity'];
                                  String productCategory = data['category'];
                                  String productPrice = data['price'];
                                  String productImage = data['imageURL'];

                                  if (name.isEmpty) {
                                    return Container(
                                      color: Colors.blue[200],
                                      margin: EdgeInsets.all(8),
                                      child: InkWell(
                                        onTap: (){
                                          quantityCounter = 1;
                                          totalPriceQuantity = double.parse(productPrice);
                                          showDialog(
                                            context: context, 
                                            builder: (context) {
                                              return StatefulBuilder(builder: (context, setState) {
                                                return Container(
                                                  padding: EdgeInsets.only(left: 400, right: 400, top: 180, bottom: 180),
                                                  child: AlertDialog(
                                                    title: Container( 
                                                      // margin: EdgeInsets.only(right: 20),
                                                      width: 100,
                                                      height: 100,
                                                      child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),  
                                                    ),
                                                    content: Column(
                                                      children: [
                                                        Text(productName, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                        Text('₱ ' + totalPriceQuantity.toStringAsFixed(2), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            IconButton(
                                                              onPressed: (){
                                                                setState(() {
                                                                  if (quantityCounter <= 1) {
                                                                    return;
                                                                  } else {
                                                                    quantityCounter--;
                                                                    totalPriceQuantity = double.parse(productPrice) * quantityCounter;
                                                                  }
                                                                  
                                                                });
                                                              }, 
                                                              icon: Icon(Icons.remove_circle_rounded, size: 50)
                                                            ),
                                                            Text(quantityCounter.toString(), textAlign: TextAlign.end, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                            IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  quantityCounter++;
                                                                  totalPriceQuantity = double.parse(productPrice) * quantityCounter;
                                                                });
                                                              },
                                                              icon: Icon(Icons.add_circle_rounded, size: 50)
                                                            ),
                                                          ],
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: (){ 
                                                            // cartItem.add([productName, quantityCounter, double.parse(totalPriceQuantity.toStringAsFixed(2))]);
                                                            // firestoreService.add2Cart(productName, quantityCounter, double.parse(totalPriceQuantity.toStringAsFixed(2)));

                                                            cartProductID.add(docID);
                                                            cartProductNames.add(productName);
                                                            cartProductQuantity.add(quantityCounter);
                                                            cartProductPrice.add(double.parse(totalPriceQuantity.toStringAsFixed(2)));
                                                            cartProductQuantityData.add(int.parse(productQuantity));



                                                            countAmount();
                                                            print(totalAmount);
                                                            print(cartProductID);
                                                            Navigator.pop(context);
                                                          }, 
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: const Color.fromARGB(255, 175, 212, 241),
                                                            // elevation: 0,
                                                            shadowColor: const Color.fromARGB(255, 49, 50, 51)
                                                          ), 
                                                          child: Text('OK')
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                            },
                                          );
                                        },
                                        child: GridTile(
                                          child: Title(
                                            color: Colors.blue,
                                            child: Column(
                                              children: [
                                                Expanded(child: Text(productName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                                                Expanded(child: Container(alignment: Alignment.topCenter, child: Text('₱ $productPrice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)))),
                                                Container(
                                                  // margin: EdgeInsets.only(right: 20),
                                                  width: 80,
                                                  height: 80,
                                                  child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),
                                                ), 
                                              ],
                                            )
                                          )
                                        ),
                                      ),
                                    );
                                  }

                                  if (data['name'].toString().startsWith(name)) {
                                    return Container(
                                      color: Colors.blue[200],
                                      margin: EdgeInsets.all(8),
                                      child: GridTile(
                                        child: Title(
                                          color: Colors.blue,
                                          child: Column(
                                            children: [
                                              Expanded(child: Text(productName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                                              Expanded(child: Container(alignment: Alignment.topCenter, child: Text('₱ $productPrice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)))),
                                              Container(
                                                // margin: EdgeInsets.only(right: 20),
                                                width: 80,
                                                height: 80,
                                                child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),
                                              ), 
                                            ],
                                          )
                                        )
                                      ),
                                    );
                                  }
                                  return Container();
                                }
                              );
                            } else {
                              return Text('No product');
                            }
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.blue[200],
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset('images/monticasa.png')
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        child: ListView.builder(
                          itemCount: cartProductNames.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                          child:
                                              Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text('${cartProductNames[index]}'))),
                                      Expanded(
                                          child: Text(
                                              '${cartProductQuantity[index]}', textAlign: TextAlign.center,)),
                                      Expanded(
                                          child:
                                              Text('${cartProductPrice[index]}'))
                                    ],
                                  ),
                                ),
                              ),
                              // height: 50,
                              // child: Text('${cartProductNames[index]} ${cartProductQuantity[index]} ${cartProductPrice[index]}'),
                            );
                          },
                        ),


                        // child: StreamBuilder<QuerySnapshot>(
                        //   stream: firestoreService.getCartStream(), 
                        //   builder: (context, snapshot) {
                        //     if (snapshot.hasData) {
                        //       List cart = snapshot.data!.docs;

                        //       return ListView.builder(
                        //         itemCount: cart.length,
                        //         itemBuilder: (context, index) {
                        //           DocumentSnapshot document = cart[index];
                        //           String docID = document.id;

                        //           Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                        //           String cartItemName = data['name'];
                        //           int quantity = data['quantity'];
                        //           double total = data['total'];

                        //           return ListTile(
                        //             title: Row(
                        //               children: [
                        //                 Expanded(flex: 3, child: Text(cartItemName, style: TextStyle(fontSize: 12))),
                        //                 Expanded(child: Text(quantity.toString(), style: TextStyle(fontSize: 12))),
                        //                 Expanded(child: Text('₱ $total', style: TextStyle(fontSize: 12))),
                        //               ],
                        //             ),
                        //           );
                        //         }
                        //       );
                        //     }
                        //     else {
                        //       return Container();
                        //     }
                        //   },
                        // )
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: Text('Total : ')
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 35),
                            alignment: Alignment.centerRight,
                            child: Text("₱ " + totalAmount.toStringAsFixed(2))),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 25),
                      height: 70,
                      width: 100,
                      child: ElevatedButton(onPressed: (){

                        for (var i = 0; i < cartProductNames.length; i++) {
                          int qtt = cartProductQuantityData[i] - cartProductQuantity[i];
                          firestoreService.quantityDeduction(cartProductID[i], qtt.toString());
                        }
                        setState(() {
                          cartProductID.clear();
                          cartProductNames.clear();
                          cartProductPrice.clear();
                          cartProductQuantity.clear();
                          cartProductQuantityData.clear();
                        });
                        
                        
                      }, child: Text('CHECK OUT')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}