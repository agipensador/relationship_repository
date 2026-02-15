import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_api.g.dart';

/// Cliente REST gerado pelo Retrofit.
/// TODO - CONECTAR COM AWS: adicionar endpoints reais quando a API estiver disponível.
/// A baseUrl é injetada em tempo de execução via NetworkModule (baseada no flavor).
@RestApi(baseUrl: 'Depends on flavor')
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  /// Endpoint de exemplo - health check da API.
  /// TODO - CONECTAR COM AWS: substituir/remover quando conectar com API real.
  @GET('/health')
  Future<HttpResponse<dynamic>> healthCheck();
}
