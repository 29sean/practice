// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practice/components/sidebar.dart';
import 'package:practice/inventory_page/inventory_category.dart';
import 'package:practice/pages/delivery.dart';
import 'package:practice/pages/inventory.dart';
import 'package:practice/pages/pos.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: Colors.blue[200],
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: Container(
                    child: Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: Colors.black),
                                        left: BorderSide(color: Colors.black),
                                        right: BorderSide(color: Colors.black),
                                      ),
                                      color: Color.fromARGB(255, 219, 222, 224)
                                    ),
                                    padding: EdgeInsets.only(left: 10),
                                    height: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: Text('Product', style: TextStyle(fontSize: 15)),
                                  )
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: Colors.black),
                                      ),
                                      color: Color.fromARGB(255, 219, 222, 224)
                                    ),
                                    padding: EdgeInsets.only(left: 10),
                                    height: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: Text('Expiry Date', style: TextStyle(fontSize: 15)),
                                  )
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: Colors.black),
                                        left: BorderSide(color: Colors.black),
                                        right: BorderSide(color: Colors.black),
                                      ),
                                      color: Color.fromARGB(255, 219, 222, 224)
                                    ),
                                    padding: EdgeInsets.only(left: 10),
                                    height: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: Text('Remarks', style: TextStyle(fontSize: 15)),
                                  )
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Color.fromARGB(255, 0, 0, 0)),
                                color: Color.fromARGB(255, 234, 235, 236)
                              ),
                              child: Center(
                                child: Text('No data available for expiring products.'),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Inventory()));
                          },
                          child: Container(
                            color: Colors.blue[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory, 
                                  size: 100,
                                ),
                                Text("Inventory", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                        )
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => POS()));
                          },
                          child: Container(
                            color: Colors.blue[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.point_of_sale, 
                                  size: 100,
                                ),
                                Text("Point of Sale", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Delivery()));
                          },
                          child: Container(
                            color: Colors.blue[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delivery_dining, 
                                  size: 100,
                                ),
                                Text("Delivery", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                        )
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => POS()));
                          },
                          child: Container(
                            color: Colors.blue[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.point_of_sale, 
                                  size: 100,
                                ),
                                Text("User Management", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
