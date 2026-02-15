import 'package:flutter/material.dart';

import 'package:love_relationship/core/config/app_config.dart';

import 'main_common.dart';

/// Entry point para o ambiente de DESENVOLVIMENTO
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(AppFlavor.dev);

  await mainCommon();
}
