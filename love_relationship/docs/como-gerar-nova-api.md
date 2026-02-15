# Como gerar uma nova API

Este guia descreve como adicionar novos endpoints ao `RestClient` e utilizá-los no projeto.

## 1. Adicionar o endpoint no RestClient

Edite o arquivo `lib/core/network/rest_api.dart` e adicione o método com as anotações do Retrofit:

```dart
@GET("/caminho/do/endpoint")
Future<HttpResponse<SeuModelo>> getAlgo(@Query("param") String param);

@POST("/caminho/do/endpoint")
Future<HttpResponse<SeuModelo>> criarAlgo(@Body() SeuDto dto);

@PUT("/caminho/do/endpoint/{id}")
Future<HttpResponse<SeuModelo>> atualizarAlgo(
  @Path("id") String id,
  @Body() SeuDto dto,
);

@DELETE("/caminho/do/endpoint/{id}")
Future<void> deletarAlgo(@Path("id") String id);
```

### Anotações úteis

| Anotação | Uso |
|----------|-----|
| `@GET`, `@POST`, `@PUT`, `@DELETE` | Método HTTP |
| `@Query("nome")` | Parâmetro na query string (?nome=valor) |
| `@Body()` | Corpo da requisição (JSON) |
| `@Path("id")` | Parâmetro no path (/recurso/{id}) |
| `@Header("X-Custom")` | Header customizado |

## 2. Criar modelos (se necessário)

Para respostas tipadas, crie o modelo com `json_serializable`:

```dart
import 'package:json_annotation/json_annotation.dart';

part 'seu_modelo.g.dart';

@JsonSerializable()
class SeuModelo {
  final String id;
  final String nome;

  SeuModelo({required this.id, required this.nome});

  factory SeuModelo.fromJson(Map<String, dynamic> json) =>
      _$SeuModeloFromJson(json);
  Map<String, dynamic> toJson() => _$SeuModeloToJson(this);
}
```

## 3. Gerar o código

Execute o build_runner para gerar o código do Retrofit (e dos modelos, se usar json_serializable):

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 4. Usar no projeto

O `RestClient` está registrado no GetIt. Use via `NetworkModule` ou injeção:

```dart
// Via NetworkModule
final response = await NetworkModule.getRestClientInstance().getAlgo("valor");

// Via GetIt (se injetado)
final response = await sl<RestClient>().getAlgo("valor");
```

## Estrutura de pastas sugerida

```
lib/
├── core/network/
│   ├── rest_api.dart      # Definição dos endpoints
│   └── rest_api.g.dart    # Código gerado (não editar)
└── features/sua_feature/
    └── data/models/       # Modelos/DTOs da feature
```
