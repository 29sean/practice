// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice/actions/firestoreService.dart';
import 'package:practice/pages/selectedOrderReceived.dart';

int selectedBatchNumber = 0;

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController batchNumField = TextEditingController();

  final TextEditingController pbarcodeid = TextEditingController();
  final TextEditingController pname = TextEditingController();
  final TextEditingController pdescription = TextEditingController();
  final TextEditingController pquan = TextEditingController();
  final TextEditingController psellingprice = TextEditingController();
  final TextEditingController punitcost = TextEditingController();
  // final TextEditingController pcat = TextEditingController();
  final TextEditingController psupplier = TextEditingController();
  final TextEditingController ppricelevel1 = TextEditingController();
  final TextEditingController ppricelevel2 = TextEditingController();
  final TextEditingController expirationDate = TextEditingController();

  bool receiveEnD = true;
  bool cancelEnD = false;
  bool addEnD = false;
  bool doneEnd = false;

  int batchNum = 0;
  String selectedCategory = '0';

  String imageURL = '';

  List barcodeList = [];
  List nameList = [];
  List descriptionList = [];
  List quantityList = [];
  List sellingPriceList = [];
  List unitCostList = [];
  List categoryList = [];
  List supplierList = [];
  List priceLevel1List = [];
  List priceLevel2List = [];
  List expirationList = [];
  List dateReceivedList = [];
  List imageList = [];

  void printOrders() {
    for (int j = 0; j < expirationList.length; j++) {
      print(expirationList[j]);
    
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Expanded(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(20),
                color: Colors.green,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        // margin: EdgeInsets.all(10),
                        child: Text('RECEIVED ORDERS HISTORY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Text('Batch Number', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))),
                            Expanded(child: Text('Date Received', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
                          ],
                        ),
                      )
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        color: Colors.white,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: firestoreService.getOrdersStream(), 
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List ordersList = snapshot.data!.docs;

                              return ListView.builder(
                                itemCount: ordersList.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document = ordersList[index];
                                  // String docID = document.id;

                                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                  int batchNumber = data['batch number'];
                                  Timestamp dateReceivedTimestamp = data['date received'];

                                  DateTime dateReceived = dateReceivedTimestamp.toDate();

                                  return ListTile(
                                    title: InkWell(
                                      onTap: () {
                                        print(batchNumber);
                                        selectedBatchNumber = batchNumber;

                                        Navigator.push(context, MaterialPageRoute(builder: (context) => selectedOrderReceived()));
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(batchNumber.toString())),
                                          Expanded(child: Text(dateReceived.toString()))
                                        ],
                                      ),
                                    ),
                                  );
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
              )
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 20, right: 20),
                      color: Colors.green,
                      child: Text('RECEIVE ORDER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20, top: 20, right: 20),
                      color: Colors.green,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Container(
                              padding: EdgeInsets.only(top: 10),
                              margin: EdgeInsets.all(20),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text('Batch Number : ${batchNum.toString()}', style: TextStyle(fontWeight: FontWeight.bold),)
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10, 
                                    child: ListView.builder(
                                      itemCount: nameList.length,
                                      itemBuilder: (context, index) {
                                        return Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: 10),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                    child:
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Text('${nameList[index]}'))),
                                                Expanded(
                                                    child: Text(
                                                        '${expirationList[index]}', textAlign: TextAlign.center,)),
                                                Expanded(
                                                    child:
                                                        Text('${categoryList[index]}'))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 20, right: 10),
                                  child: ElevatedButton(onPressed: receiveEnD ? () {
                                    setState(() {
                                      receiveEnD = false;
                                    });
                                    showDialog(
                                      context: context, 
                                      builder: (context) {
                                        return Dialog(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Enter Batch Number'),
                                              Container(
                                                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                width: 200,
                                                child: TextField(
                                                  controller: batchNumField,
                                                  decoration: InputDecoration()
                                                ),
                                              ),
                                              ElevatedButton(onPressed: (){
                                                setState(() {
                                                  batchNum = int.parse(batchNumField.text);

                                                  cancelEnD = true;
                                                  addEnD = true;
                                                  doneEnd = true;
                                                  receiveEnD = false;
                                                });
                                                print(batchNum);
                                                Navigator.pop(context);
                                              }, 
                                              child: Text('OK'))
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  :null, 
                                  child: Text('Receive')),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                                  child: ElevatedButton(onPressed: doneEnd ? () {
                                    for (var i = 0; i < nameList.length; i++) {
                                        firestoreService.receiveProduct(int.parse(batchNum.toString()), int.parse(barcodeList[i].toString()), nameList[i].toString().toUpperCase(), descriptionList[i].toString(), int.parse(quantityList[i].toString()), double.parse(sellingPriceList[i].toString()), double.parse(unitCostList[i].toString()), categoryList[i].toString().toUpperCase(), supplierList[i].toString().toUpperCase(), int.parse(priceLevel1List[i].toString()), int.parse(priceLevel2List[i].toString()), imageList[i].toString(), expirationList[i], dateReceivedList[i], 'STORED'.toUpperCase());
                                    }
                                    firestoreService.addReceivedOrders(int.parse(batchNum.toString()), DateTime.now());
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
                                                    child: Text("ORDER RECEIVED!"),
                                                  ),
                                                  TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      batchNum = 0;
                                                      barcodeList.clear();
                                                      nameList.clear();
                                                      descriptionList.clear();
                                                      quantityList.clear();
                                                      sellingPriceList.clear();
                                                      unitCostList.clear();
                                                      categoryList.clear();
                                                      supplierList.clear();
                                                      priceLevel1List.clear();
                                                      priceLevel2List.clear();
                                                      imageList.clear();
                                                      expirationList.clear();
                                                      dateReceivedList.clear();
                                                    });
                                                  }, 
                                                  child: Text("OK"))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    
                                    setState(() {
                                      receiveEnD = true;
                                      cancelEnD = false;
                                      doneEnd = false;
                                      addEnD = false;
                                    });
                                  }                                 
                                  :null, 
                                  child: Text('Done')),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                                  child: ElevatedButton(onPressed: addEnD ? () {
                                    showDialog(
                                      context: context, 
                                      builder: (context) {
                                        return Dialog(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('PRODUCT'),
                                                Container(
                                                  width: 400,
                                                  padding: EdgeInsets.only(left: 40, right: 40),
                                                  child: TextField(
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                      FilteringTextInputFormatter.digitsOnly
                                                    ],
                                                    controller: pbarcodeid,
                                                    decoration: InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Enter Barcode ID',
                                                    )
                                                  )
                                                ),
                                                Container(
                                                  width: 400,
                                                  padding: EdgeInsets.only(left: 40, right: 40),
                                                  child: TextField(
                                                    controller: pname,
                                                    decoration: InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Enter Product Name',
                                                    )
                                                  )
                                                ),
                                                Container(
                                                  width: 400,
                                                  padding: EdgeInsets.only(left: 40, right: 40),
                                                  child: TextField(
                                                    controller: pdescription,
                                                    decoration: InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Enter Product Description',
                                                    )
                                                  )
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
                                                    decoration: InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Enter Product Quantity',
                                                    )
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
                                                    controller: psellingprice,
                                                    decoration: InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Enter Product Selling Price',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 400,
                                                  padding: EdgeInsets.only(left: 40, right: 40),
                                                  child: TextField(
                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                                    ],
                                                    controller: punitcost,
                                                    decoration: InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Enter Product Unit Cost',
                                                    ),
                                                  ),
                                                ),                   
                                                Container(
                                                  width: 400,
                                                  padding: EdgeInsets.only(left: 40, right: 40),
                                                  child: StreamBuilder(
                                                    stream: FirebaseFirestore.instance.collection('category').snapshots(), 
                                                    builder: (context, snapshot) {
                                                      List<DropdownMenuItem> categoryList = [];
                                      
                                                      if (!snapshot.hasData) {
                                                        CircularProgressIndicator();
                                                      }
                                                      else{
                                                        final categories = snapshot.data?.docs.reversed.toList();
                                      
                                                        categoryList.add(DropdownMenuItem(
                                                          value: '0',
                                                          child: Text('Select Category'),
                                                        ));
                                      
                                                        for (var category in categories!) {
                                                          categoryList.add(DropdownMenuItem(
                                                            value: category['name'],
                                                            child: Text(category['name'])
                                                          ));
                                                        }
                                                      }
                                                      return StatefulBuilder(
                                                        builder: (context, setState) {
                                                          return DropdownButton(
                                                            items: categoryList, 
                                                            onChanged: (categoryValue){
                                                              setState(() {
                                                                selectedCategory = categoryValue;
                                                              });
                                                              // print(categoryValue);
                                                            },
                                                            value: selectedCategory,
                                                            isExpanded: true,
                                                          );
                                                        },
                                                        
                                                      );
                                                    }
                                                  ),
                                                ),
                                                Container(
                                                  width: 400,
                                                  padding: EdgeInsets.only(left: 40, right: 40),
                                                  child: TextField(
                                                    controller: psupplier,
                                                    decoration: InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Choose Product Supplier',
                                                    )
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
                                                    controller: ppricelevel1,
                                                    decoration: InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Enter Price Level 1',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 400,
                                                  padding: EdgeInsets.only(left: 40, right: 40),
                                                  child: TextField(
                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                                    ],
                                                    controller: ppricelevel2,
                                                    decoration: InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Enter Price Level 2',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 400,
                                                  padding: EdgeInsets.only(left: 40, right: 40),
                                                  child: TextField(
                                                    controller: expirationDate,
                                                    decoration: InputDecoration(
                                                      labelText: 'Expiration Date',
                                                      filled: true,
                                                      prefixIcon: Icon(Icons.calendar_today),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide.none
                                                      ),
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)
                                                      ),
                                                    ),
                                                    readOnly: true,
                                                    onTap: () {
                                                      selectDate();
                                                    },
                                                  ),
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
                                                      final bytes = await file.readAsBytes();
                                                      await referenceImageToUpload.putData(bytes);
                                                      String imageURL = await referenceImageToUpload.getDownloadURL();
                                                      setState(() {
                                                        this.imageURL = imageURL;
                                                      });
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                  icon: Icon(Icons.camera_alt),
                                                ),
                                                ElevatedButton(onPressed: () {
                                                  setState(() {
                                                    barcodeList.add(int.parse(pbarcodeid.text));
                                                  nameList.add(pname.text.toUpperCase());
                                                  descriptionList.add(pdescription.text.toUpperCase());
                                                  quantityList.add(int.parse(pquan.text));
                                                  sellingPriceList.add(double.parse(psellingprice.text));
                                                  unitCostList.add(double.parse(punitcost.text));
                                                  categoryList.add(selectedCategory.toString().toUpperCase());
                                                  supplierList.add(psupplier.text.toUpperCase());
                                                  priceLevel1List.add(int.parse(ppricelevel1.text));
                                                  priceLevel2List.add(ppricelevel2.text);
                                                  expirationList.add(DateTime.parse(expirationDate.text));
                                                  dateReceivedList.add(DateTime.now());
                                                  imageList.add(imageURL);
                                                  });
                                                  

                                                  for (var i = 0; i < nameList.length; i++) {
                                                    print(nameList[i]);
                                                  }

                                                  Navigator.pop(context);
                                                }, 
                                                child: Text('OK'))
                        
                                              ],
                                            ),
                                          ),
                                        );    
                                      }
                                    );
                                  }
                                  :null, 
                                  child: Text('Add Item')),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 20, left: 10),
                                  child: ElevatedButton(
                                    onPressed: cancelEnD ? () {
                                      setState(() {
                                        batchNumField.text = '';
                                        batchNum = 0;
                                        barcodeList.clear();
                                        nameList.clear();
                                        descriptionList.clear();
                                        quantityList.clear();
                                        sellingPriceList.clear();
                                        unitCostList.clear();
                                        categoryList.clear();
                                        supplierList.clear();
                                        priceLevel1List.clear();
                                        priceLevel2List.clear();
                                        imageList.clear();
                                        expirationList.clear();
                                        dateReceivedList.clear();
                                        receiveEnD = true;
                                        cancelEnD = false;
                                        doneEnd = false;
                                        addEnD = false;
                                      });
                                    }
                                    :null, 
                                    child: Text('Cancel')
                                  ),
                                )
                              ]
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ),
          ],
        )
      ),
    );
  }
  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );

    if (picked != null) {
      setState(() {
        expirationDate.text = picked.toString().split(" ")[0];
      });
    } else {
      
    }
  }
}
