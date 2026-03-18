# Afazeres

- [x] App mantém logado mesmo quando fecha o app
- [ ] Publicar na loja Android Play Store para teste interno
- [ ] Criar login e cadastro com o Google
- [ ] Esqueci a senha: ao clicar em enviar e ter enviado, informar com Snackbar que o email foi enviado; e voltar em 5 segundos para a tela de login
- [ ] Esqueci a senha deve recuperar por SMS ou WhatsApp também
- [ ] Ajustar coração na tela de Home
- [ ] Menu/Configurações de perfil do usuário, ou seja, tela de editar algumas infos do usuário
- [ ] Sincronizar casais com um código gerado pelo app, e enviado para o outro; Isto deve funcionar de forma que o usuário inicia o app, e conecta em uma pessoa como casal
- [ ] Jogos devem ser funcionalidades de "Em breve"
- [ ] Implementar chat conforme TODO_CHAT.md (backend AWS, multimodal, áudio, chamadas, IA)
- [ ] As fotos/documentos/links adicionadas no chat devem estar em CHIPS, como o WhatsApp (quando clica no usuário ou em ícone três pontinhos, deve carregar mais opções)
- [ ] Adicionar métricas corretamente utilizando o Analytics e Crashlytics do Firebase

---

## iOS: google_mobile_ads + webview_flutter_wkwebview

- [ ] **Resolver conflito CocoaPods vs Swift Package Manager**  
  O `google_mobile_ads` usa CocoaPods enquanto o `webview_flutter_wkwebview` usa Swift Package Manager.  
  **Status atual:** SPM desabilitado no `pubspec.yaml` (`enable-swift-package-manager: false`) para usar apenas CocoaPods.  
  **A fazer:**  
  - Acompanhar quando o `google_mobile_ads` passar a suportar Swift Package Manager ([issue #1239](https://github.com/googleads/googleads-mobile-flutter/issues/1239)).  
  - Remover `enable-swift-package-manager: false` assim que o conflito for resolvido (versões futuras do Flutter podem não permitir desabilitar SPM).  
  - Avaliar atualizar `google_mobile_ads` ou `webview_flutter_wkwebview` quando houver versões compatíveis com ambos os gerenciadores.

---

## iOS: Configurar notificação push (FCM)

- [ ] **API key no firebase_options.dart**  
  Garantir que o iOS use API key real (não dummy). Rodar `flutterfire configure` ou atualizar manualmente.

- [ ] **APNs no Firebase Console**  
  - Firebase Console → Project Settings → Cloud Messaging  
  - Em "Apple app configuration", adicionar APNs Authentication Key (.p8) ou APNs Certificates (.p12)

- [ ] **Capability no Xcode**  
  - Abrir `ios/Runner.xcworkspace` no Xcode  
  - Target Runner → Signing & Capabilities → + Capability → Push Notifications

- [ ] **Testar em dispositivo físico** (push não funciona no simulador iOS)
