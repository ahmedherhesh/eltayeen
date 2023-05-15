import 'package:flutter/material.dart';
import 'package:soldiers_food/helpers/constants.dart';
import 'package:soldiers_food/helpers/db.dart';

customDrawer() {
  DB db = DB();
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: primaryColor,
          ),
          child: Text(
            'المجندين',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        FutureBuilder(
            future: db.get(table: 'users'),
            builder: (context, AsyncSnapshot snapshot) {
              List data = snapshot.data ?? [];
              return Column(
                  children: List.generate(
                data.length,
                (i) => ListTile(
                  title: Text(data[i]['fullname']),
                  leading: const Icon(Icons.person),
                  onTap: () {},
                ),
              ));
            }),
      ],
    ),
  );
}
