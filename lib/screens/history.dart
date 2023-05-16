import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soldiers_food/helpers/constants.dart';
import 'package:soldiers_food/helpers/db.dart';
import 'package:soldiers_food/widgets/appbar.dart';
import 'package:date_field/date_field.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DB db = DB();
  String selectedDate = date;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: customAppBar(
          title: 'المعاملات السابقة',
          actions: [
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Container(
                        alignment: Alignment.center,
                        child: const Text('هل تريد حذف كل المعاملات '),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('إلغاء'),
                          onPressed: () {
                            Get.back();
                            setState(() {});
                          },
                        ),
                        TextButton(
                          child: const Text('تأكيد'),
                          onPressed: () async {
                            await db.delete('DELETE FROM transactions');
                            Get.back();
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.only(top: 20, right: padding, left: padding),
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black45),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'التاريخ',
                ),
                mode: DateTimeFieldPickerMode.date,
                autovalidateMode: AutovalidateMode.always,
                onDateSelected: (DateTime value) {
                  String val = "$value".split(' ')[0];
                  setState(() => selectedDate = val);
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: db.get(
                  table: 'transactions',
                  join:
                      "INNER JOIN users ON transactions.userId = users.id INNER JOIN items ON transactions.itemId = items.id AND transactions.date='$selectedDate' ORDER BY id desc;",
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
                        'لا توجد تعاملات لليوم',
                        style: textStyle,
                      ),
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.all(padding),
                    children: [
                      ...List.generate(
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
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
