import 'package:flutter/material.dart';
import 'package:soldiers_food/helpers/constants.dart';

customAppBar(title) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    backgroundColor: primaryColor,
  );
}
