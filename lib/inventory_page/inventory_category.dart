// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practice/pages/inventory.dart';

String category = '';

class InventoryCategory extends StatefulWidget {
  const InventoryCategory({super.key});

  @override
  State<InventoryCategory> createState() => _InventoryCategoryState();
}

class _InventoryCategoryState extends State<InventoryCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Inventory"),
        backgroundColor: Colors.blue[500],
      ),
      body: Container(
        color: Colors.blue[300],
        child: Center(
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
                    // color: Colors.blue[100],
                    width: 300,
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      child: Text("ALL ITEMS"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        elevation: 0,
                        shadowColor: const Color.fromARGB(255, 49, 50, 51)
                      ),
                      onPressed: () {
                        category = 'ALL ITEMS';
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Inventory()));
                      },
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      // color: Colors.blue[200],
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                        children: [
                          myBox(context, 'ADULT DIAPERS'),
                          myBox(context, 'BABY DIAPERS'),
                          myBox(context, 'BABY ESSENTIALS'),
                          myBox(context, 'BEVERAGES'),
                          myBox(context, 'BODY ESSENTIALS'),
                          myBox(context, 'BRANDED NEBULE'),
                          myBox(context, 'BRANDED SUSP/SYR'),
                          myBox(context, 'BRANDED TAB/CAP/SUPP'),
                          myBox(context, 'CONTRACEPTIVES'),
                          myBox(context, 'EAR CARE'),
                          myBox(context, 'EYE CARE'),
                          myBox(context, 'GENERIC NEBULE'),
                          myBox(context, 'GENERIC TAB/CAP'),
                          myBox(context, 'GENERIC SUSP/SYR'),
                          myBox(context, 'HERBAL MEDS'),
                          myBox(context, 'LOZENGES'),
                          myBox(context, 'MEDICAL SUPPLY'),
                          myBox(context, 'MILK'),
                          myBox(context, 'NOSE CARE'),
                          myBox(context, 'OINTMENTS/LINIMENTS/CREAMS'),
                          myBox(context, 'ORAL CARE'),
                          myBox(context, 'OTHERS'),
                          myBox(context, 'SUPPOSITORY'),
                          myBox(context, 'TEA/COFFEE/HERBAL DRINKS'),
                          myBox(context, 'THROAT CARE'),
                          // myBox(context, 'ALL ITEMS'),
                        ],
                      ),
                    ),
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
Widget myBox(context, String catName){
  return InkWell(
    onTap: () {
      category = catName;
      Navigator.push(context, MaterialPageRoute(builder: (context) => Inventory()));
    },
    child: Container(
      color: Colors.green[200],
      margin: EdgeInsets.all(15),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text('$catName', style: TextStyle(fontWeight: FontWeight.bold))
              ),
            ),
          ],
        )
      ),
    ),
  );
}