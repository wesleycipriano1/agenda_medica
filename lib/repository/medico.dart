class Medico {
  final String nome;
  final String crm;
  final String especialidade;

  Medico({
    required this.nome,
    required this.crm,
    required this.especialidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'crm': crm,
      'especialidade': especialidade,
    };
  }

  factory Medico.fromMap(Map<String, dynamic> map) {
    return Medico(
      nome: map['nome'],
      crm: map['crm'],
      especialidade: map['especialidade'],
    );
  }

  factory Medico.fromJson(Map<String, dynamic> json) => Medico(
        nome: json['nome'],
        crm: json['crm'],
        especialidade: json['especialidade'],
      );
}
