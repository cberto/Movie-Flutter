import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/proviers/peliculas_provider.dart';

// el encargado de disparar un método muy Debé para traerme las películas conforme la persona va
//a escribiéndola en la caja que va a aparecer ahí.
//extiende de la clase abstracta SearchDelegate
class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

//listado para crear el builSuggestions
  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Ironman',
    'Capitan America',
    'Superman',
    'Ironman 2',
    'Ironman 3',
    'Ironman 4',
    'Ironman 5',
  ];

  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          //para q limpie el buscador
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      //iconos animados
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        //transicion del icno
        progress: transitionAnimation,
      ),
      onPressed: () {
        //para cerrarar el boton de busqueda e ir para atras <---, va a la pantalla de inicio
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      //container vacio
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        //devolvemos la tarjeta
        if (snapshot.hasData) {
          final peliculas = snapshot.data;

          return ListView(
              //es extraer de convertir mi películas mi listado de películas en un arreglo o una colección
              children: peliculas.map((pelicula) {
            return ListTile(
              leading: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(pelicula.title),
              subtitle: Text(pelicula.originalTitle),
              onTap: () {
                //cerramos la busqueda
                close(context, null);
                //no puede ser nulo entonces lo pogno vacio la busqueda
                pelicula.uniqueId = '';

                //navegar a otro lugar
                Navigator.pushNamed(context, 'detalle', arguments: pelicula);
              },
            );
          }).toList());
        } else {
          //loading
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  // Son las sugerencias que aparecen cuando la persona escribe

  //   final listaSugerida = ( query.isEmpty )
  //                           ? peliculasRecientes
  //                           : peliculas.where(
  //condicion, regresa ierable, y lista
  //                             (p)=> p.toLowerCase().startsWith(query.toLowerCase())
  //                           ).toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugerida[i]),
  //         onTap: (){
  //           seleccion = listaSugerida[i];
  //           showResults( context );
  //         },
  //       );
  //     },
  //   );
  // }

}
