import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practice/pages/inventory.dart';
import 'package:practice/pages/login.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            'Admin',
            style: TextStyle(fontSize: 25),
          ),
          accountEmail: Text('admin@gmail.com'),
          currentAccountPicture: Icon(
            Icons.account_circle_rounded,
            size: 55,
          ),
          decoration: BoxDecoration(color: Colors.blue[200]),
        ),
        ListTile(
          leading: Icon(Icons.money),
          title: Text(
            "Sales",
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.inventory_rounded),
          title: Text(
            "Inventory",
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Inventory()));
          },
        ),
        ListTile(
          leading: Icon(Icons.point_of_sale_sharp),
          title: Text(
            "Point of Sale",
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Inventory()));
          },
        ),
        ListTile(
          leading: Icon(Icons.manage_accounts_rounded),
          title: Text(
            "User Management",
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {},
        ),
        SizedBox(height: 325),
        ListTile(
          leading: Icon(Icons.logout_outlined),
          title: Text(
            "Logout",
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
        ),
      ],
    ));
  }
}
