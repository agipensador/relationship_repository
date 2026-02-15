import 'package:flutter/material.dart';

import 'package:love_relationship/core/config/app_config.dart';

import 'main_common.dart';

/// Entry point padrão - detecta automaticamente o flavor baseado no tipo de build
/// Debug = dev, Release = prod
/// Para ambientes específicos, use:
/// - main_dev.dart (desenvolvimento)
/// - main_qa.dart (QA/homologação)
/// - main_prd.dart (produção)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initializeAuto();

  await mainCommon();
}
