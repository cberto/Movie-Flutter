import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = '42ba9f7cb85450be706644df6b7764cc';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  //corriente de datos, coleccion de peliculas (list de peliculas)
  //contenedor de peliculas
  List<Pelicula> _populares = new List();
  //string
  //.broadcast muchos lugares escuchando el stream

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();
//insertr inf, argrega pedidad , introducire
  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
//string emita, esuchar las peliculas
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    //pregunta si tiene el metodo close se llama sino no hace nada porque el streamControle no tiene inf
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    //generar el url
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _procesarRespuesta(url);
    /*
    //peticion http poenr el paquete de flutter htpp
    //retorna la variable htpp
    //espera la solicitud para guardarla
    final resp = await http.get(url);
    //decodificar la data
    final decodedData = json.decode(resp.body);
    //transofrmar en peliculas
    //se encargad e barrer todos los resultados en la lista y enerar las peliculas
    //for de pelicula model
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    //print(peliculas.items[1].title);

    //lo tranforma y lo impro
    //trae el listado completo
    //print(decodedData['results']);

    //coleccion de listas
    return peliculas.items;
    */
  }

  Future<List<Pelicula>> getPopulares() async {
    //antes de increementar
//pregunta si esta cargando
    if (_cargando) return [];
//sino returna tru
    _cargando = true;
    //getpopulares trae la sig pagin inf
//incrementasmos en 1
    _popularesPage++;

    // print('Cargando siguientes....');
    //generar el url
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);
    //añadir toda la respuesta odo la iterable
    //añadimos inf al stream mediante mediante el sink

    _populares.addAll(resp);
    //mandar o colocarlo en el inicio de datos
    popularesSink(_populares);

    _cargando = false;
    return resp;
    //OPTIMIZAR
    //return await _procesarREspuesta(url);

/*
    // final resp = await http.get(url);

    ///  final decodedData = json.decode(resp.body);

    // final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    // return peliculas.items;
    */
  }

  Future<List<Actor>> getCast(String peliId) async {
    //creamos el url
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    //agarra el body y lo transforma en mapa,
    final decodedData = json.decode(resp.body);
//mandamos el mapa
    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _procesarRespuesta(url);
  }
}
