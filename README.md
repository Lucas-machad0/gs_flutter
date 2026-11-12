Projeto: EntrePáginas - Troca de livros na sua comunidade
Global Solution 2026.2 - FIAP

Integrantes:
    Lucas Machado 557431
    Pedro Salimon 555038
-----------------------------------------------------------------------------------
Link GitHub: https://github.com/Lucas-machad0/gs_flutter
-----------------------------------------------------------------------------------

Aplicativo mobile desenvolvido em Flutter para troca de livros entre leitores da mesma comunidade.

O usuário cadastra os livros que quer trocar, informando o seu nome e o estado de conservação do livro. O título, o autor e a capa são buscados automaticamente na API da Open Library. Depois, ele consulta os livros de outros leitores e propõe uma troca, oferecendo um livro seu.

Os livros da comunidade são dados fictícios (mock), com as capas salvas nos assets do projeto. Os livros cadastrados e as propostas de troca ficam salvos no próprio aparelho com SharedPreferences.

As imagens das telas estão na pasta images_screens.

------------------

Tema da Global Solution

O projeto está ligado aos Objetivos de Desenvolvimento Sustentável (ODS) da ONU:

ODS 4 - Educação de qualidade: facilita o acesso à leitura.

ODS 11 - Cidades e comunidades sustentáveis: livros que já existem voltam a circular entre os leitores da comunidade.

------------------

Fluxo de telas

Splash → Introdução → Tela principal

Se o usuário marcou "Não mostrar novamente", a Splash vai direto para a Tela principal.

Tela principal (barra inferior):
    Livros → Detalhes do livro → Propor troca
    Meus livros → Cadastrar livro
    Trocas

------------------

Splash Screen

Exibe o logo, o nome EntrePáginas e o slogan "Troca de livros na sua comunidade".

Após 3 segundos, verifica no SharedPreferences se a introdução já foi dispensada e redireciona para a Introdução ou para a Tela principal.

------------------

Intro Screen

Introdução com 3 páginas:

Página 1: "Cadastre seus livros" - explica como cadastrar um livro com o nome e o estado.

Página 2: "Encontre na comunidade" - mostra que é possível ver os livros de outros leitores.

Página 3: "Proponha uma troca" - explica que o usuário pode oferecer um livro seu.

Cada página possui imagem, título, descrição e os botões Voltar e Avançar. Um indicador de pontos mostra a página atual. A opção "Não mostrar novamente" fica salva no SharedPreferences.

------------------

Livros

Lista todos os livros, os do usuário e os da comunidade, com busca por título, autor ou leitor.

Ao tocar em um livro, abre a tela de detalhes.

------------------

Meus livros

Lista os livros cadastrados pelo usuário e tem o botão "Cadastrar livro".

------------------

Cadastrar livro

Campos para o nome do usuário e o nome do livro. A busca na API mostra 1 resultado, com capa, título e autor.

O usuário escolhe o estado do livro: Novo, Bom estado, Usado ou Desgastado.

A busca tem os estados inicial, carregando, sucesso e erro. Em caso de erro aparece uma mensagem e o botão "Tentar novamente".

------------------

Detalhes do livro

Mostra capa, título, autor, leitor e estado do livro.

Se o livro for de outro leitor, mostra o botão "Propor troca". Se for do usuário, permite remover o livro.

------------------

Propor troca

O usuário escolhe um dos seus livros para oferecer.

A proposta aparece como "Troca livro X por livro Y".

------------------

Trocas

Lista as propostas enviadas, com o status "Aguardando resposta" e a opção de cancelar.

------------------

API utilizada

Open Library Search API (pública e sem chave de acesso)

https://openlibrary.org/search.json?title=Dom%20Casmurro&limit=1

A requisição é feita com o pacote http.

O JSON é convertido no objeto Dart LivroApi pelo método fromJson, usando os campos title, author_name e cover_i.

A capa vem de https://covers.openlibrary.org/b/id/{cover_i}-M.jpg e é exibida com Image.network.

------------------

Arquitetura

lib
    main.dart - MaterialApp, tema e rotas
    navigation - app_routes.dart (nomes das rotas) e app_navigation.dart (onGenerateRoute)
    models - livro.dart, livro_api.dart, troca.dart e status_busca.dart
    data - livros_mock.dart (livros fictícios da comunidade)
    services - open_library_service.dart (API com http) e armazenamento_service.dart (SharedPreferences)
    ui
        app_cores.dart - cores do app
        components - top_bar, livro_card, capa_livro, etiqueta e mensagem (widgets reutilizáveis)
        screens - splash, intro, principal, livros, meus_livros, trocas, cadastro, detalhes e propor_troca

assets/images - logo, imagens da introdução e capas dos livros mockados (pasta livros)

Models: classes que representam os dados e convertem JSON em objetos Dart.

Services: separam o acesso aos dados das telas. O OpenLibraryService faz a requisição HTTP e o ArmazenamentoService salva e lê os dados no SharedPreferences.

Navigation: navegação com rotas nomeadas. O livro escolhido é passado como parâmetro para as telas de Detalhes e Propor troca.

UI: as telas usam StatefulWidget com setState para atualizar a interface, e StatelessWidget quando não têm estado. Os componentes são reaproveitados em várias telas.

------------------

Tecnologias

Flutter e Dart
http - consumo da API
shared_preferences - persistência local

------------------

Como executar

flutter pub get
flutter run