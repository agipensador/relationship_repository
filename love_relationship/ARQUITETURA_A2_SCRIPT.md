# 🧠 Script de Arquitetura A2 — love_relationship

Documento de arquitetura completa do aplicativo **love_relationship** (nome comercial: **A2**), focado em relacionamentos (inicialmente casais, escalável para grupos).

Baseado na arquitetura definida em `A2_Arquitetura_Completa.pdf` e alinhado ao estado atual do app.

---

# 🧱 STACK

| Componente | Tecnologia | Observação |
|------------|------------|------------|
| **Auth** | AWS Cognito (Amplify) | Já implementado |
| **Database** | AWS (DynamoDB / AppSync) | Backend completo |
| **Storage** | AWS S3 | Áudios, gravações, mídia |
| **Backend** | AWS Lambda + API Gateway | Processamento, transcrição, IA |
| **Push** | Firebase Cloud Messaging (FCM) | Apenas para notificações push |
| **Flutter** | BLoC obrigatório | Padrão atual |

**Princípio:** AWS para dados e processamento; Firebase **apenas** para FCM (push).

---

# 🧠 PRINCÍPIOS

- **Privacidade em primeiro lugar**
- **IA assistiva, nunca invasiva**
- **Sistema multimodal** (texto, áudio, chamadas)
- **Escalável** para N usuários
- **Arquitetura modular e extensível**

---

# 📱 NOTIFICAÇÕES PUSH (FCM)

## Visão geral

- **FCM** é o único uso de Firebase no app.
- **AWS Lambda** dispara os pushes via Firebase Admin SDK.
- Tokens FCM são armazenados em DynamoDB por usuário.

## Modos de envio

| Modo | Descrição | Implementação |
|------|-----------|----------------|
| **Usuário específico** | Push para um único usuário (ex: ID xxx) | Lambda busca token do usuário em DynamoDB e envia via FCM |
| **Grupo específico** | Push para membros de um relacionamento | Lambda usa FCM Topics (ex: `relationship_{id}`) |
| **Todos os usuários** | Push broadcast | Lambda usa FCM Topic `all` ou envia para lista de tokens |

## Estrutura de dados (DynamoDB)

```
user_fcm_tokens:
  - user_id (PK)
  - fcm_token
  - platform (android | ios)
  - updated_at
```

## Fluxo

1. App registra token FCM no login e envia para API (Lambda).
2. Lambda persiste/atualiza token em DynamoDB.
3. Quando necessário enviar push:
   - **Usuário:** Lambda busca token do `user_id` → envia via FCM.
   - **Grupo:** Lambda publica em topic `relationship_{relationshipId}`.
   - **Todos:** Lambda publica em topic `all` ou itera tokens.

## Lambda (Firebase Admin SDK)

- Lambda com Firebase Admin SDK (credenciais do projeto Firebase).
- Endpoint ou evento que recebe: `target_type` (user | topic | all), `target_id`, `payload`.

---

# 💬 CHAT

## Tipos de chat

| Tipo | Descrição |
|------|-----------|
| **COUPLE_CHAT** | Chat compartilhado entre os dois do casal |
| **PRIVATE_AI** | Chat privado do usuário com a IA (não compartilhado) |

## Tipos de mensagem

| Tipo | Descrição |
|------|-----------|
| **TEXT** | Mensagem de texto |
| **AUDIO** | Áudio gravado (URL no S3) |
| **AUDIO_TRANSCRIBED** | Transcrição do áudio + metadados |
| **AI_MESSAGE** | Resposta da IA |
| **AI_SUGGESTION** | Sugestão da IA (ex: criar tarefa) |
| **CALL_SUMMARY** | Resumo de chamada processada |
| **CALL_EVENT** | Evento de chamada (início/fim) |
| **VIDEO_EVENT** | Evento de vídeo |

## Campos obrigatórios em toda mensagem

- `senderType`: user | partner | ai
- `metadata`: `{ emotion?, intent?, origin? }`

---

# 🎤 ÁUDIO

- **Upload** via AWS S3
- **Transcrição** opcional (consentimento em `user_settings.audio_ai_enabled`)
- **Detecção de emoção** após transcrição
- **Integração** com pipeline de IA

## Consentimento

> "Podemos usar seus áudios para melhorar sua experiência?"

- `audio_ai_enabled: false` → não transcreve
- `audio_ai_enabled: true` → transcrição + emoção + IA

## UI

- Player de áudio
- Botão "Ver transcrição" (somente se `audio_ai_enabled == true`)

---

# 📞 CHAMADAS

## Estrutura (DynamoDB)

```
call_sessions:
  - id
  - participants
  - type: audio | video
  - started_at, ended_at
  - recording_url
  - intelligent_mode_enabled
  - processed
```

## Modo inteligente (opcional)

- **Pré-chamada:** "Ativar modo inteligente e transcrever a chamada ao final?" (Sim | Não)
- **Pós-chamada:** "Posso criar algo com essa conversa?" (Criar tarefas | Gerar resumo | Ignorar)
- **Processamento:** upload → transcrição → resumo → extração de ações
- **Resultado:** `CALL_SUMMARY` + sugestões de tools

## Privacidade

- Chamadas **não** são analisadas sem consentimento
- Apenas pós-processamento (nada em tempo real)

---

# 🧠 IA

## Pipeline

```
Mensagem → Intenção → Decisão → Tools
```

## Tools

- `create_event`
- `create_task`
- `save_memory`

## RAG

- Uso de memórias estruturadas para contexto

---

# 🧠 MEMÓRIA

- **Estruturada** — eventos, tarefas, preferências
- **Emocional** — `audio_emotional_patterns`
- **Timeline** — `call_summaries`

---

# 📊 INTELIGÊNCIA DE PRODUTO

- `feature_signals` — sinais de uso (texto, áudio, chamadas)
- `feature_insights` — insights agregados
- **Relatório diário** para admin

Exemplo de sinal: `topic: "planejamento_viagem"`

---

# ⚠️ PRIVACIDADE

- Separação total entre **privado** (PRIVATE_AI) e **compartilhado** (COUPLE_CHAT)
- Consentimento obrigatório para áudio e chamadas
- Nunca analisar sem consentimento
- IA sempre sugerir, nunca forçar

---

# 🧱 AWS — ESTRUTURA DE DADOS

## Tabelas / Collections

| Tabela | Uso |
|--------|-----|
| `relationships` | Casais/grupos |
| `messages` | Mensagens do chat |
| `user_settings` | Preferências (ex: `audio_ai_enabled`) |
| `user_fcm_tokens` | Tokens FCM por usuário |
| `audio_processing` | Status de processamento de áudio |
| `call_sessions` | Sessões de chamada |
| `call_insights` | Insights extraídos de chamadas |
| `memories` | Memórias estruturadas e emocionais |
| `feature_signals` | Sinais de produto |
| `feature_insights` | Insights agregados |

---

# 🧠 ARQUITETURA FLUTTER (BLoC)

| BLoC | Responsabilidade |
|------|------------------|
| **ChatBloc** | Mensagens, COUPLE_CHAT, PRIVATE_AI |
| **AudioBloc** | Gravação, upload S3, player, transcrição |
| **CallBloc** | Sessões, modo inteligente |
| **AIBloc** | Pipeline IA, tools, sugestões |
| **MemoryBloc** | Memória emocional, call_summaries |

Manter **Clean Architecture** por feature (data / domain / presentation).

---

# 🧠 BACKEND (AWS)

- **Lambda** — transcrição, processamento de áudio, IA, tools, envio de push FCM
- **API Gateway** — REST (Retrofit no app)
- **S3** — áudios, gravações
- **Transcribe** — transcrição de áudio
- **SQS** — filas assíncronas para processamento pesado

---

# 🎯 OBJETIVO FINAL

Sistema que:

- Entende texto
- Entende áudio
- Entende contexto de chamadas
- Aprende com usuários
- Evolui o produto automaticamente

---

# 📍 ESTADO ATUAL DO APP (baseline)

- **Auth:** AWS Cognito ✅
- **Chat:** UI pronta, mensagens mockadas
- **Features:** Splash, Auth, Home, Chat, Games, Ads, Editar perfil
- **Pendências:** Ver `AFAZERES.md` e `TODO_CHAT.md`

---

*Documento alinhado a `A2_Arquitetura_Completa.pdf`. Última atualização: março 2025.*
