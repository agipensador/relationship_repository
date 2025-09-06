import 'package:flutter/material.dart';

class AppNavKeys {
  static final tabHome = GlobalKey<NavigatorState>();
  static final tabRegister = GlobalKey<NavigatorState>();
  static final tabEditUser = GlobalKey<NavigatorState>();
  static final tabGames = GlobalKey<NavigatorState>();

  static List<GlobalKey<NavigatorState>> get all => [
    tabHome,
    tabRegister,
    tabEditUser,
    tabGames,
  ];
}
