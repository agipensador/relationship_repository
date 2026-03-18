# 📋 TODO CHAT — Checklist Detalhado

Checklist passo a passo para desenvolver o chat com excelência, conforme `ARQUITETURA_A2_SCRIPT.md` e `A2_Arquitetura_Completa.pdf`.

---

## FASE 1 — Base AWS

### 1.1 Infraestrutura

- [ ] Criar tabelas DynamoDB (ou schema AppSync):
  - [ ] `relationships`
  - [ ] `messages`
  - [ ] `user_settings`
  - [ ] `user_fcm_tokens`
  - [ ] `audio_processing`
  - [ ] `call_sessions`
  - [ ] `call_insights`
- [ ] Configurar API Gateway + Lambda para endpoints REST
- [ ] Configurar bucket S3 para áudios e gravações
- [ ] Configurar SQS para filas assíncronas (processamento pesado)

### 1.2 FCM + Push

- [ ] Adicionar `firebase_core` e `firebase_messaging` ao `pubspec.yaml`
- [ ] Configurar Firebase no projeto (Android/iOS)
- [ ] Implementar registro de token FCM no app (após login)
- [ ] Endpoint Lambda para receber e persistir token em `user_fcm_tokens`
- [ ] Lambda com Firebase Admin SDK para envio de push
- [ ] Suporte a envio: usuário específico, grupo (topic), todos (topic)

---

## FASE 2 — Relacionamentos

- [ ] Modelo de dados: `Relationship` (id, participants, created_at, etc.)
- [ ] Sincronizar casais por código (gerar código, conectar parceiro)
- [ ] API: criar relacionamento, entrar por código, listar relacionamento do usuário
- [ ] Flutter: tela/flow para conectar casal por código

---

## FASE 3 — Chat Real (Backend)

### 3.1 Estrutura de dados

- [ ] Definir schema de `Message`:
  - [ ] `id`, `chat_type` (COUPLE_CHAT | PRIVATE_AI), `relationship_id?`
  - [ ] `message_type` (TEXT | AUDIO | AUDIO_TRANSCRIBED | AI_MESSAGE | AI_SUGGESTION | CALL_SUMMARY | CALL_EVENT | VIDEO_EVENT)
  - [ ] `sender_type` (user | partner | ai)
  - [ ] `content` (texto ou URL)
  - [ ] `metadata` (emotion, intent, origin)
  - [ ] `timestamp`, `sender_id`
- [ ] API: enviar mensagem, listar mensagens (paginação), real-time (AppSync/WebSocket ou polling)

### 3.2 Flutter — Chat base

- [ ] Remover mensagens mockadas do `ChatBloc`
- [ ] `ChatRepository` + `ChatRemoteDatasource` (API REST ou AppSync)
- [ ] `ChatBloc`: carregar mensagens do backend, enviar mensagem
- [ ] Persistir mensagens em DynamoDB
- [ ] Push ao receber nova mensagem (FCM → atualizar chat)

---

## FASE 4 — Mensagens Multimodais

### 4.1 Modelo expandido

- [ ] Expandir `ChatMessage` (ou criar `Message` entity):
  - [ ] `MessageType` enum
  - [ ] `senderType`
  - [ ] `metadata` (emotion, intent, origin)
- [ ] Mapear todos os tipos: TEXT, AUDIO, AUDIO_TRANSCRIBED, AI_MESSAGE, AI_SUGGESTION, CALL_SUMMARY, CALL_EVENT, VIDEO_EVENT

### 4.2 UI por tipo

- [ ] `ChatMessageBubble` para TEXT
- [ ] `ChatMessageBubble` para AUDIO (player + "Ver transcrição")
- [ ] `ChatMessageBubble` para AI_MESSAGE
- [ ] `ChatMessageBubble` para AI_SUGGESTION (ações: aceitar/ignorar)
- [ ] `ChatMessageBubble` para CALL_SUMMARY
- [ ] `ChatMessageBubble` para CALL_EVENT / VIDEO_EVENT

### 4.3 COUPLE_CHAT vs PRIVATE_AI

- [ ] Navegação entre COUPLE_CHAT e PRIVATE_AI (menu ou tabs)
- [ ] Garantir separação de dados (privado nunca misturado com compartilhado)

---

## FASE 5 — Áudio

### 5.1 Gravação e upload

- [ ] Pacote de gravação de áudio (ex: `record`, `flutter_sound`)
- [ ] `AudioBloc`: gravar, parar, cancelar
- [ ] Upload para S3 (presigned URL ou Lambda)
- [ ] Criar mensagem tipo AUDIO com URL do S3

### 5.2 Player

- [ ] Player de áudio na bolha de mensagem
- [ ] Controles: play, pause, barra de progresso

### 5.3 Consentimento

- [ ] Tela/dialog na primeira vez: "Podemos usar seus áudios para melhorar sua experiência?"
- [ ] Salvar `audio_ai_enabled` em `user_settings` (DynamoDB + local)
- [ ] Botão "Ver transcrição" visível somente se `audio_ai_enabled == true`

---

## FASE 6 — Transcrição + Emoção

- [ ] Lambda: receber URL do áudio, chamar Transcribe
- [ ] Lambda: detecção de emoção (ex: Comprehend ou modelo custom)
- [ ] Criar mensagem AUDIO_TRANSCRIBED com texto + metadata (emotion, confidence)
- [ ] SQS para processamento assíncrono
- [ ] Atualizar mensagem no chat quando transcrição estiver pronta
- [ ] Integrar com memória emocional

---

## FASE 7 — Pipeline IA Multimodal

- [ ] Lambda: classificação de intenção (texto + transcrição)
- [ ] Lambda: decisão (qual tool usar)
- [ ] Tools: `create_event`, `create_task`, `save_memory`
- [ ] Criar mensagens AI_MESSAGE e AI_SUGGESTION
- [ ] RAG com memórias para contexto

---

## FASE 8 — Chamadas (Infraestrutura)

- [ ] Escolher SDK (WebRTC, Agora, Twilio, etc.)
- [ ] Tabela `call_sessions` em uso
- [ ] Iniciar/finalizar chamada, gravar (se consentido)
- [ ] Upload de gravação para S3

---

## FASE 9 — Modo Inteligente (Chamadas)

- [ ] UX pré-chamada: "Ativar modo inteligente?" (Sim | Não)
- [ ] Salvar `intelligent_mode_enabled` na sessão
- [ ] Processamento pós-chamada (se enabled): transcrição, resumo, extração de ações
- [ ] UX pós-chamada: "Posso criar algo com essa conversa?" (Criar tarefas | Gerar resumo | Ignorar)
- [ ] Criar CALL_SUMMARY e sugestões de tools

---

## FASE 10 — Integração Tools

- [ ] Conectar áudio e chamadas ao pipeline de tools
- [ ] Criar tarefas/eventos a partir de sugestões
- [ ] Salvar memórias a partir de conversas

---

## FASE 11 — Memória

- [ ] `audio_emotional_patterns` — padrões emocionais por usuário/relacionamento
- [ ] `call_summaries` — resumos indexados
- [ ] Integração com IA (RAG)

---

## FASE 12 — Inteligência de Produto

- [ ] Extrair `feature_signals` de texto, áudio, chamadas
- [ ] `feature_insights` agregados
- [ ] Relatório diário para admin

---

## FASE 13 — Chat — Detalhes de UX

- [ ] Fotos/documentos/links em chips (estilo WhatsApp)
- [ ] Menu três pontinhos com opções adicionais
- [ ] Mensagem "para quando estivermos perto" (placeholder/localização futura)
- [ ] Mensagem "pro futuro" (placeholder)
- [ ] Indicador de digitação (opcional)
- [ ] Indicador de entrega/lido (opcional)

---

## FASE 14 — Admin Insights

- [ ] Dashboard com métricas
- [ ] Relatório diário
- [ ] Visualização de sinais e insights

---

## Resumo de dependências

```
FASE 1 (Base) → FASE 2 (Relacionamentos) → FASE 3 (Chat real)
    → FASE 4 (Multimodal) → FASE 5 (Áudio) → FASE 6 (Transcrição)
    → FASE 7 (Pipeline IA) → FASE 8 (Chamadas) → FASE 9 (Modo inteligente)
    → FASE 10 (Tools) → FASE 11 (Memória) → FASE 12 (Inteligência)
    → FASE 13 (UX) → FASE 14 (Admin)
```

---

*Documento de referência para desenvolvimento do chat. Atualizar conforme progresso.*
