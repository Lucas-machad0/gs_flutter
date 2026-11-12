class Troca {
  final String id;
  final String livroOferecido; // seu livro
  final String livroDesejado; // livro que você quer
  final String donoDesejado; // dono do livro que você quer
  final String status;

  const Troca({
    required this.id,
    required this.livroOferecido,
    required this.livroDesejado,
    required this.donoDesejado,
    this.status = 'Aguardando resposta',
  });

  factory Troca.fromJson(Map<String, dynamic> json) {
    return Troca(
      id: json['id'] ?? '',
      livroOferecido: json['livroOferecido'] ?? '',
      livroDesejado: json['livroDesejado'] ?? '',
      donoDesejado: json['donoDesejado'] ?? '',
      status: json['status'] ?? 'Aguardando resposta',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'livroOferecido': livroOferecido,
      'livroDesejado': livroDesejado,
      'donoDesejado': donoDesejado,
      'status': status,
    };
  }
}
