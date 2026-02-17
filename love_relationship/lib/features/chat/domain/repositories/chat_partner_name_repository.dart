/// Repositório para persistir o nome do parceiro escolhido pelo usuário.
/// TODO ALTERAR PARA O NOME DO PARCEIRO, QUE VIRÁ DO BANCO;
/// DEPOIS O PRÓPRIO USUÁRIO PODE ESCOLHER UM NOME.
abstract class ChatPartnerNameRepository {
  Future<String> getPartnerName();
  Future<void> savePartnerName(String name);
}
