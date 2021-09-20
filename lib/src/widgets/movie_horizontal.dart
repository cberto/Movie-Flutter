import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;
  //a fuerza las peliculas
  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
      initialPage: 1,
      //cuantas tarjetas mostramos
      viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    //20% de la panalla
    final _screenSize = MediaQuery.of(context).size;
//obtener la posicon en pixeles
    _pageController.addListener(() {
      //se dispara cuando se mueve el scroll de la app de Populares
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      //20%
      height: _screenSize.height * 0.22,
      //pagaview renderizar tyoodos los elementos q tenga pelicula
      //y el PageView.build los rederiza  cuando es necesario, creando cuandos on necesaros
      //permite crear una lista crolleable
      child: PageView.builder(
        //sacar el magneto
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas(context),
        //cuantos items va a renderizar
        itemCount: peliculas.length,
        // mandamos una funcion
        itemBuilder: (context, i) => _tarjeta(context, peliculas[i]),
        /* lo reemplazamos
        PageController(
          initialPage: 1,
          //cuantas tarjetas mostramos
          viewportFraction: 0.3,
        ),*/
        // children: _tarjetas(context),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          //transicion de elemento de un lado a otro
          Hero(
            //le establecemos el uniqueID
            tag: pelicula.uniqueId,
            //bordes
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ),
          //nombre abajo de la pelicula
          //separacion
          SizedBox(height: 5.0),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
//devulve el detector
    return GestureDetector(
      child: tarjeta,
      onTap: () {
        //Navegadar de pantalas este y pelicula detalle
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
        //print('Id de la pelicula: ${pelicula.id}');
      },
    );
  }
  //retornar la lista

  List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            //bordes
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            //nombre abajo de la pelicula
            //separacion
            SizedBox(height: 5.0),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}
