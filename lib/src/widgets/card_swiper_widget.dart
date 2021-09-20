import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

//staless porque vamos a ener varias tarjetas y no lo manejamos por el card sino por el widget, le mandamos po r argumento

class CardSwiper extends StatelessWidget {
  //lista de tarjetas para mostrar, lista de coleccion
  final List<Pelicula> peliculas;
  //inicializarlo, required para q lo mande a la fuerza
  CardSwiper({@required this.peliculas});

  @override
  //este  build se va a llmar cuando se utilice el CardWiper
  Widget build(BuildContext context) {
    //determinar el ancho
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        //especificar las dimensiones
        /*todo el ancho posible*/
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        //contruye imagenes desde esa direccion web, es como un for
        itemBuilder: (BuildContext context, int index) {
          //haer un id unico sin repetir en las imagenes de pelicula con el poster
          //hace ref al uniqueId, concatenear q viene de tarjeta
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

          return Hero(
            //le  mandamos el tag de uniqueId
            tag: peliculas[index].uniqueId,
            //borde redondeado
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                //implementar el detector
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'detalle',
                      arguments: peliculas[index]),
                  child: FadeInImage(
                    image: NetworkImage(peliculas[index].getPosterImg()),
                    //img q se muestra mientras carga
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                    //child: Image.network(
                    //"http://via.placeholder.com/350x150",
                    //imagen se adaspte a las dimensiones q tiene
                    // fit: BoxFit.cover,
                  ),
                )),
          );
        },
        itemCount: peliculas.length,
        //puntos de la pagina
        //pagination: new SwiperPagination(),
        //flechas para deslizar
        // control: new SwiperControl(),
      ),
    );
  }
}
