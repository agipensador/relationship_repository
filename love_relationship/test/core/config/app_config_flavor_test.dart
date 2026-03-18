import 'package:flutter_test/flutter_test.dart';
import 'package:love_relationship/core/config/app_config.dart';

void main() {
  group('AppConfig - Verificação de Flavor', () {
    test('flavor dev: appName deve ser "A2" (DEV)', () {
      AppConfig.initialize(AppFlavor.dev);

      expect(AppConfig.instance.appName, '"A2" (DEV)');
      expect(AppConfig.instance.flavor.name, 'DEV');
      expect(AppConfig.instance.isDev, isTrue);
      expect(AppConfig.instance.baseUrl, 'http://localhost:3000');
    });

    test('flavor qa: appName deve ser "A2" (QA)', () {
      AppConfig.initialize(AppFlavor.qa);

      expect(AppConfig.instance.appName, '"A2" (QA)');
      expect(AppConfig.instance.flavor.name, 'QA');
      expect(AppConfig.instance.isQA, isTrue);
      expect(AppConfig.instance.baseUrl, contains('api-qa'));
    });

    test('flavor prod: appName deve ser "A2"', () {
      AppConfig.initialize(AppFlavor.prod);

      expect(AppConfig.instance.appName, '"A2"');
      expect(AppConfig.instance.flavor.name, 'PROD');
      expect(AppConfig.instance.isProd, isTrue);
      expect(AppConfig.instance.baseUrl, contains('api'));
    });

    test('cada flavor deve ter bundleIdSuffix correto', () {
      AppConfig.initialize(AppFlavor.dev);
      expect(AppConfig.instance.flavor.bundleIdSuffix, '.dev');

      AppConfig.initialize(AppFlavor.qa);
      expect(AppConfig.instance.flavor.bundleIdSuffix, '.qa');

      AppConfig.initialize(AppFlavor.prod);
      expect(AppConfig.instance.flavor.bundleIdSuffix, '');
    });

    test('flavor dev deve ter connectionTimeout de 90 segundos', () {
      AppConfig.initialize(AppFlavor.dev);
      expect(AppConfig.instance.connectionTimeout, const Duration(seconds: 90));
    });
  });
}
