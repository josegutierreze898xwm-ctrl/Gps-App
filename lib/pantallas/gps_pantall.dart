import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';

class GpsPantall extends StatefulWidget {
  const GpsPantall({super.key});

  @override
  State<GpsPantall> createState() => _GpsPantallState();
}

class _GpsPantallState extends State<GpsPantall> {

  String mensaje='';
  double latitud=0;
  double longitud=0;

  //variable para caotrolar el mapa
  final MapController miMapcontroller = MapController();

  //Ubucación por defecto inicial al momneto de cargar el mapa
  LatLng ubicacionInicail= const LatLng(14.6253428, -90.5113095);
  bool tieneUbicacion=false;

//future porque se activa y despues de unos segundos o minutos obtiene los resultados

 Future<void> obtenerUbicacion()async{
bool servicioHabilitado;
LocationPermission tengoPermisos;

  //verificar si se encuentra activo el servicio de ubicación
  servicioHabilitado = await Geolocator.isLocationServiceEnabled();
  if (servicioHabilitado){
    setState(() {
      mensaje='Servicio de ubicación activado';
    });
  }else{
    setState(() {
      mensaje='Servicio de ubicación desactivado';
    });
    return;
  }
  //verificar si tengo los permisos para la ubicación
  tengoPermisos = await Geolocator.checkPermission();

  if (tengoPermisos == LocationPermission.denied){
    tengoPermisos == await Geolocator.requestPermission();
    print(tengoPermisos);
    if(tengoPermisos== LocationPermission.denied){
      setState(() {
        mensaje='Los permisos de ubucacion fueron permitidos';
      });
      return;
    }else{
      mensaje='Los mensajes de ubicacion fueron denegados';
    }
  }
  //obtener la ubicacion actual
  setState(() {
    mensaje = 'Obteniendo Ubicación Actual......';
      });
      Position posicion = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds:15)
      )
      );
  // mostrar los datos de ubucacion geografica
 setState(() {
   latitud=posicion.latitude;
   longitud=posicion.longitude;
   //asignar la nueva ubucacion a la variable ubicacion inicial
   ubicacionInicail = LatLng(posicion.latitude, posicion.longitude);
   //controla el marcador del mapa 
   tieneUbicacion=true;
   mensaje= 'Ubicacon obtenida con exito';
 });
 miMapcontroller.move(ubicacionInicail, 16.0);
 }

 void compartirUbicacion(){
  if(!tieneUbicacion){
    setState(() {
      mensaje='Primero debes obtener una ubuicación antes de compartir';
    });
    return;
  }
  final String textoParacompartir=
  'Hola esta es mi ubicación\n'
  'desde mi App\n'
  'Latitud $latitud\n'
  'longitud $longitud\n\n'
  'José Gutiérrez';

  SharePlus.instance.share(
    ShareParams(
      text: textoParacompartir,
      subject: 'Mi ubicación GPS',
    )
  );
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,

          title: Text('GPS Flutter'),
        ),
        body: SizedBox.expand(
          child: Column(
          children: [

            SizedBox(
              height: 150,
              width: double.infinity,
              child: FlutterMap(
                mapController: miMapcontroller,
                options: MapOptions(
                  initialCenter: ubicacionInicail,
                  initialZoom: 12.0,
                ),
                children:[
                  TileLayer(
                    urlTemplate: 'https:/tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.flutter_gps',
                  ),
                  //Capa de marcadores
                  MarkerLayer(
                    markers: [
                      if(tieneUbicacion)
                      Marker(
                        point: ubicacionInicail, 
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 45,
                        ))
                    ])
                ]),
            ),
        
        const SizedBox(height: 150,),


        Text('Presione El Botón Para\n   Obtener Ubicación', style: TextStyle(fontSize: 30),),
        SizedBox(height: 20,),

        Text('Latitud $latitud', style: TextStyle(fontSize: 20),),
        SizedBox(height: 15,),
        
        Text('Longitud $longitud',  style: TextStyle(fontSize: 20),),
        SizedBox(height: 15,),

        Text('Mensaje: $mensaje',  style: TextStyle(fontSize: 20),),
        SizedBox(height: 15,),


        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white
              ),
              onPressed: obtenerUbicacion, 
              child: Text('Obtener Ubicación')),
              
              ElevatedButton(
                onPressed: compartirUbicacion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white
                ), 
                child: Icon(Icons.share_rounded)),
          ],
        )

      ],
           ) )
    );
  }
}