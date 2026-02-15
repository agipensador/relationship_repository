import 'package:flutter/material.dart';

import 'package:love_relationship/core/config/app_config.dart';

import 'main_common.dart';

/// Entry point para o ambiente de PRODUÇÃO
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(AppFlavor.prod);

  await mainCommon();
}
