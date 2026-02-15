import 'package:flutter/foundation.dart';

/// Enum para os ambientes (flavors) da aplicação
/// dev = desenvolvimento local, qa = homologação, prod = produção
enum AppFlavor {
  dev,
  qa,
  prod;

  /// Nome do flavor em String
  String get name {
    switch (this) {
      case AppFlavor.dev:
        return 'DEV';
      case AppFlavor.qa:
        return 'QA';
      case AppFlavor.prod:
        return 'PROD';
    }
  }

  /// Sufixo do bundle ID
  String get bundleIdSuffix {
    switch (this) {
      case AppFlavor.dev:
        return '.dev';
      case AppFlavor.qa:
        return '.qa';
      case AppFlavor.prod:
        return '';
    }
  }

  /// Nome para exibição
  String get displayName {
    switch (this) {
      case AppFlavor.dev:
        return 'Love Relationship (DEV)';
      case AppFlavor.qa:
        return 'Love Relationship (QA)';
      case AppFlavor.prod:
        return 'Love Relationship';
    }
  }
}

/// Configuração da aplicação baseada no flavor
class AppConfig {
  final AppFlavor flavor;
  final String appName;
  final String baseUrl;
  final bool debugMode;
  final bool showDebugBanner;
  final String apiKey;

  AppConfig._({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    required this.debugMode,
    required this.showDebugBanner,
    required this.apiKey,
  });

  /// Instância singleton
  static AppConfig? _instance;

  /// Obtém a instância atual
  static AppConfig get instance {
    if (_instance == null) {
      throw Exception(
        'AppConfig não foi inicializado. '
        'Chame AppConfig.initialize() no main.dart',
      );
    }
    return _instance!;
  }

  /// Verifica se já foi inicializado
  static bool get isInitialized => _instance != null;

  /// Detecta automaticamente o flavor baseado no tipo de build
  static AppFlavor _detectFlavor() {
    if (kDebugMode) {
      return AppFlavor.dev;
    }
    return AppFlavor.prod;
  }

  /// Inicializa a configuração com o flavor especificado
  static void initialize(AppFlavor flavor) {
    _instance = AppConfig._(
      flavor: flavor,
      appName: flavor.displayName,
      baseUrl: _getBaseUrl(flavor),
      debugMode: _isDebugMode(flavor),
      showDebugBanner: false,
      apiKey: _getApiKey(flavor),
    );

    if (kDebugMode) {
      debugPrint('AppConfig initialized with flavor: ${flavor.name}');
      debugPrint('App Name: ${_instance!.appName}');
      debugPrint('Base URL: ${_instance!.baseUrl}');
      debugPrint('Debug Mode: ${_instance!.debugMode}');
    }
  }

  /// Inicializa a configuração automaticamente baseada no tipo de build
  static void initializeAuto() {
    final flavor = _detectFlavor();
    initialize(flavor);

    if (kDebugMode) {
      debugPrint('AppConfig auto-initialized with flavor: ${flavor.name}');
      debugPrint(
        'Tip: Use AppConfig.initialize(AppFlavor.xxx) to override auto-detection',
      );
    }
  }

  /// Obtém a URL base conforme o flavor
  /// TODO - CONECTAR COM AWS: substituir pelas URLs reais quando disponíveis
  static String _getBaseUrl(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        // TODO - CONECTAR COM AWS: URL da API dev (ex: https://api-dev.xxx.execute-api.region.amazonaws.com)
        return 'http://localhost:3000';
      case AppFlavor.qa:
        // TODO - CONECTAR COM AWS: URL da API QA
        return 'https://api-qa-placeholder.example.com';
      case AppFlavor.prod:
        // TODO - CONECTAR COM AWS: URL da API produção
        return 'https://api-placeholder.example.com';
    }
  }

  /// Define se o modo debug está ativo
  static bool _isDebugMode(AppFlavor flavor) {
    return flavor == AppFlavor.dev || kDebugMode;
  }

  /// Obtém a API Key conforme o ambiente
  /// TODO - CONECTAR COM AWS: configurar API Keys reais quando disponíveis
  static String _getApiKey(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return 'dev_api_key_placeholder';
      case AppFlavor.qa:
        return 'qa_api_key_placeholder';
      case AppFlavor.prod:
        return 'prod_api_key_placeholder';
    }
  }

  /// Configurações de timeout conforme ambiente
  Duration get connectionTimeout {
    switch (flavor) {
      case AppFlavor.dev:
        return const Duration(seconds: 90);
      case AppFlavor.qa:
        return const Duration(seconds: 90);
      case AppFlavor.prod:
        return const Duration(seconds: 60);
    }
  }

  Duration get receiveTimeout {
    switch (flavor) {
      case AppFlavor.dev:
        return const Duration(seconds: 120);
      case AppFlavor.qa:
        return const Duration(seconds: 120);
      case AppFlavor.prod:
        return const Duration(seconds: 90);
    }
  }

  /// Verifica se é ambiente de desenvolvimento
  bool get isDev => flavor == AppFlavor.dev;

  /// Verifica se é ambiente de QA
  bool get isQA => flavor == AppFlavor.qa;

  /// Verifica se é ambiente de produção
  bool get isProd => flavor == AppFlavor.prod;

  /// Retorna informações do ambiente em String
  @override
  String toString() {
    return 'AppConfig{\n'
        '  flavor: ${flavor.name},\n'
        '  appName: $appName,\n'
        '  baseUrl: $baseUrl,\n'
        '  debugMode: $debugMode,\n'
        '  showDebugBanner: $showDebugBanner,\n'
        '}';
  }
}
