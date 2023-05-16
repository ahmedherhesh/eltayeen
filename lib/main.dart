import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:soldiers_food/helpers/db.dart';
import 'package:soldiers_food/helpers/constants.dart';
import 'package:soldiers_food/screens/add_food.dart';
import 'package:soldiers_food/screens/add_transaction.dart';
import 'package:soldiers_food/screens/add_user.dart';
import 'package:soldiers_food/screens/history.dart';
import 'package:soldiers_food/screens/profile.dart';
import 'package:soldiers_food/screens/users.dart';
import 'package:soldiers_food/widgets/appbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: const Home(),
      theme: ThemeData(
        fontFamily: 'Cairo',
        primaryColor: primaryColor,
        primarySwatch: Colors.blueGrey,
      ),
      routes: {
        'home': (context) => const Home(),
        'add_user': (context) => const AddUser(),
        'add_food': (context) => const AddFood(),
        'add_transaction': (context) => const AddTransaction(),
        'history': (context) => const History(),
        'users': (context) => const Users(),
        'profile': (context) => const Profile(),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DB db = DB();
  resetTables() async {
    await db.delete('DELETE FROM users');
    await db.delete('DELETE FROM items');
    await db.delete('DELETE FROM transactions');
  }

  @override
  void initState() {
    // resetTables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appTitle),
      body: FutureBuilder(
        future: db.get(
          table: 'transactions',
          join:
              "INNER JOIN users ON transactions.userId = users.id INNER JOIN items ON transactions.itemId = items.id AND transactions.date='$date' ORDER BY id desc;",
        ),
        builder: (context, AsyncSnapshot snapshot) {
          List data = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (data.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد تعاملات',
                style: textStyle,
              ),
            );
          }
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: List.generate(
                data.length,
                (i) => Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    textColor: Colors.white,
                    onTap: () {},
                    title: Text('${data[i]['fullname']}'),
                    subtitle: Text('${data[i]['title']}'),
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    trailing: Text('الكميه : ${data[i]['qty']} '),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: primaryColor,
        elevation: 1,
        spacing: 12,
        spaceBetweenChildren: 12,
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor:Colors.blueGrey,

        children: [
          SpeedDialChild(
            child: const Icon(Icons.add_circle),
            onTap: () async {
              var result = await Get.toNamed('add_transaction');
              if (result == 1) setState(() {});
            },
            label: 'معامله جديده',
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_business_sharp),
            onTap: () => Get.toNamed('add_food'),
            label: 'إضافة طعام',
          ),
          SpeedDialChild(
            child: const Icon(Icons.history_toggle_off_rounded),
            onTap: () => Get.toNamed('history'),
            label: 'المعاملات السابقه',
          ),
          SpeedDialChild(
            child: const Icon(Icons.person_add),
            onTap: () async {
              var result = await Get.toNamed('add_user');
              if (result == 1) setState(() {});
            },
            label: 'مجند جديد',
          ),
          SpeedDialChild(
            child: const Icon(Icons.group),
            onTap: () {
              Get.toNamed('users');
            },
            label: 'المجندين',
          ),
        ],
      ),
    );
  }
}
