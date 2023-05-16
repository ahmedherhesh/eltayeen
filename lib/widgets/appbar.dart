import 'package:flutter/material.dart';
import 'package:soldiers_food/helpers/constants.dart';

customAppBar({title, actions}) {
  return AppBar(
    actions: actions,
    title: Text(title),
    centerTitle: true,
    backgroundColor: primaryColor,
  );
}
