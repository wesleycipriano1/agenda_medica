class Medico {
  String id;
  final String email;
  final String senha;
  final String nome;
  final String crm;
  final String especialidade;

  Medico({
    this.id = '',
    required this.email,
    required this.senha,
    required this.nome,
    required this.crm,
    required this.especialidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'senha': senha,
      'nome': nome,
      'crm': crm,
      'especialidade': especialidade,
    };
  }

  factory Medico.fromMap(Map<String, dynamic> map) {
    return Medico(
      id: map['id'],
      email: map['email'],
      senha: map['senha'],
      nome: map['nome'],
      crm: map['crm'],
      especialidade: map['especialidade'],
    );
  }

  factory Medico.fromJson(Map<String, dynamic> json) => Medico(
        id: json['id'],
        email: json['email'],
        senha: json['senha'],
        nome: json['nome'],
        crm: json['crm'],
        especialidade: json['especialidade'],
      );
}
