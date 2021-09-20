import 'package:flutter/material.dart';
import 'package:peliculas/src/proviers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';
import 'package:peliculas/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
//poner los componentes
    peliculasProvider.getPopulares();

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Películas en cines'),
          backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              //busqueda
              onPressed: () {
                //lo q se escribe en la caja de texto de busqueda
                showSearch(
                  context: context,
                  //importar el Dataserch
                  delegate: DataSearch(),
                  //algo recargado en la barra de buscar apenas se abre
                  // query: 'Hola'
                );
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[_swiperTarjetas(), _footer(context)],
          ),
        ));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
          //cuando no tenemos inf
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
          //final peliculasProvider = new PeliculasProvider();
          //lamar al metodo, retorna la lista de peliculas
          // peliculasProvider.getEnCine();
          //para utilizar
          //return CardSwiper(
          //  peliculas: [1, 2, 3, 4, 5],
          //);
          //para ver si funciona el widget
          //return Container();
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      //agarre todo el espacio
      width: double.infinity,
      child: Column(
        //columna
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //tema paa los textos el textTheme, esta en material app
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.subtitle1)),
          SizedBox(height: 5.0),
          //FutureBuilder
          StreamBuilder(
            //future: peliculasProvider.getPopulares(),
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
              //print(snapshot.data);
              /* ? hace el forEchar si existe data
                snapshot.data?.forEach((p) => print(p.title));*/
              //list completo
              //return Container();
            },
          ),
        ],
      ),
    );
  }
}
