// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:consumo_api/movie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumo API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Movie> movies = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de Api"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: "Título do Filme...",
                  border: OutlineInputBorder(),
                ),
                onChanged: (title) => atualizarLista(title),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(movies[index].title),
                      subtitle: Text(movies[index].year),
                      leading: Image.network(
                        movies[index].poster,
                        height: 240,
                        width: 230,
                        fit: BoxFit.scaleDown,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  atualizarLista(String title) {
    const int nMinimoCaracteres = 2;
    if (title.length > nMinimoCaracteres) {
      acessaOMDB(title).then((movies) {
        setState(() {
          this.movies = movies;
        });
      });
    }
  }

  Future acessaOMDB(String title) async {
    const String key = "8e8bd0de";
    String uri = "https://omdbapi.com/?apikey=$key&s=$title";
    var response = await http.get(Uri.parse(uri));
    if (response.statusCode != 200) {
      throw Exception("Erro ao acessar a API ");
    }
    List<Movie> movies = [];
    var json = jsonDecode(response.body);
    var result = json["Search"];
    if (result == null) {
      return;
    }
    for (var movie in result) {
      movies.add(Movie.fromJson(movie));
    }
    return movies;
  }
}
