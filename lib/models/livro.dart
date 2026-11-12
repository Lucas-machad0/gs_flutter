class Livro {
  final String id;
  final String titulo;
  final String autor;
  final String imagem;
  final String dono;
  final String estado;
  final bool ehMeu;

  const Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.imagem,
    required this.dono,
    required this.estado,
    this.ehMeu = false,
  });

  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      autor: json['autor'] ?? '',
      imagem: json['imagem'] ?? '',
      dono: json['dono'] ?? '',
      estado: json['estado'] ?? '',
      ehMeu: json['ehMeu'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'imagem': imagem,
      'dono': dono,
      'estado': estado,
      'ehMeu': ehMeu,
    };
  }
}
