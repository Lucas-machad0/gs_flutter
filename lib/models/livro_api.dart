class LivroApi {
  final String titulo;
  final String autor;
  final String capaUrl;

  LivroApi({
    required this.titulo,
    required this.autor,
    required this.capaUrl,
  });

  factory LivroApi.fromJson(Map<String, dynamic> json) {
    final autores = json['author_name'] as List?;
    final idCapa = json['cover_i'];

    return LivroApi(
      titulo: json['title'] ?? 'Sem título',
      autor: autores == null || autores.isEmpty
          ? 'Autor desconhecido'
          : autores.first.toString(),
      capaUrl: idCapa == null
          ? ''
          : 'https://covers.openlibrary.org/b/id/$idCapa-M.jpg',
    );
  }
}
