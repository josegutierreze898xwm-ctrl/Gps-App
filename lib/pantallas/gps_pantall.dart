import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gps/database_helper.dart';
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

Future<void> guardarUbicacion(BuildContext context) async{
    //ingresamos nuestro primer registro
    Map<String, dynamic> nuevaUbicacion = {
      'longitud' : 121221.00,
      'latitud' : 231231321.00,
      'fecha' : '16-10-2026',
      'hora' : '14:54'
      
        )

      ],
           ) )
    );
  }
}