# Analytics — Tabs e Modais para customização

Este documento lista as **tabs** e **modais** do app que precisam de tracking manual (fora do Observer), para que você possa customizar os nomes ou adicionar parâmetros.

---

## Tabs (PersistentTabView)

O Observer **não** captura troca de tabs — elas não usam `Navigator.push`. O tracking está em `AppShell` via `onTabChanged`.

| Índice | Tela        | Nome atual no Analytics | Arquivo              |
|--------|-------------|--------------------------|----------------------|
| 0      | Home        | `tab_home`               | `app_shell.dart`     |
| 1      | Games       | `tab_games`              | `app_shell.dart`     |
| 2      | Ads         | `tab_ads`                | `app_shell.dart`     |
| 3      | Chat        | `tab_chat`               | `app_shell.dart`     |
| 4      | Editar User | `tab_edit_user`          | `app_shell.dart`     |

**Onde customizar:** `lib/core/navigation/app_shell.dart` → array `tabScreenNames` e callback `onTabChanged`.

---

## Modais

Atualmente o app **não possui** `showDialog` nem `showModalBottomSheet`. Quando adicionar:

1. **Com rota nomeada:** passe `routeSettings: RouteSettings(name: 'nome_da_tela')` para o modal ser capturado pelo Observer.
2. **Sem rota:** use `FirebaseAnalytics.instance.logScreenView(screenName: '...', screenClass: '...')` manualmente ao abrir.

---

## Rotas (Observer automático)

Estas são capturadas automaticamente pelo `FirebaseAnalyticsObserver`:

| Rota                         | Nome no Analytics          |
|-----------------------------|----------------------------|
| Splash                      | `/`                        |
| Login                       | `/login`                   |
| Register                    | `/register`                |
| Home (standalone)           | `/home`                    |
| Edit User (standalone)      | `/edit_user`               |
| Shell (bottom nav)          | `/shell`                   |
| Forgot Password             | `/forgot_password`         |
| Games (standalone)          | `/games`                   |
| Chat Mensagem Proximidade   | `/chat/mensagem_proximidade` |
| Chat Mensagem Futuro        | `/chat/mensagem_futuro`    |
