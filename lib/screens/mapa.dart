import 'dart:async';
import 'dart:io'; // Usamos esto para verificar la conexión
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Coordenadas del TecNM Celaya (Campus II)
  static const LatLng _tecnmCelayaLocation = LatLng(20.540867, -100.813147);

  // Posición inicial de la cámara
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: _tecnmCelayaLocation,
    zoom: 17.0, // Zoom adecuado para ver el campus
  );

  // Marcadores y polígonos
  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {
    Polygon(
      polygonId: PolygonId('tec_polygon'),
      points: [
        LatLng(20.527250, -100.814500),
        LatLng(20.528000, -100.814200),
        LatLng(20.528300, -100.813000),
        LatLng(20.527000, -100.812800),
        LatLng(20.526600, -100.813700),
      ],
      strokeWidth: 2,
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
    ),
  };

  // Tipos de mapa disponibles
  MapType _currentMapType = MapType.hybrid;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _markers.add(Marker(
      markerId: MarkerId('TECNM CELAYA CAMPUS II'),
      position: _tecnmCelayaLocation,
      infoWindow: InfoWindow(
        title: 'TECNM CELAYA CAMPUS II',
        snippet: 'La mejor Universidad',
      ),
    ));
  }

  Future<void> _checkInternetConnection() async {
    try {
      // Intentamos conectarnos a un servidor conocido
      final result = await InternetAddress.lookup('google.com');
      setState(() {
        _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      });
    } on SocketException catch (_) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa del TecNM Celaya'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: _changeMapType,
          ),
        ],
      ),
      body: _isConnected
          ? GoogleMap(
              mapType: _currentMapType,
              initialCameraPosition: _kGooglePlex,
              markers: _markers,
              polygons: _polygons,
              onTap: _addMarker,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    'No hay conexión a internet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _checkInternetConnection,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
      floatingActionButton: _isConnected
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  onPressed: _zoomIn,
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  onPressed: _zoomOut,
                  child: const Icon(Icons.zoom_out),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: _goToTheLocation,
                  label: const Text('Ir al Tec'),
                  icon: const Icon(Icons.directions),
                ),
              ],
            )
          : null,
    );
  }

  // Cambiar el tipo de mapa
  void _changeMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.hybrid ? MapType.normal : MapType.hybrid;
    });
  }

  // Agregar marcador en la posición donde se hace clic
  void _addMarker(LatLng position) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
          title: 'Nuevo Marcador',
          snippet: '${position.latitude}, ${position.longitude}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    });
  }

  // Funcionalidad para acercar el zoom
  Future<void> _zoomIn() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomIn());
  }

  // Funcionalidad para alejar el zoom
  Future<void> _zoomOut() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomOut());
  }

  // Ir a la ubicación principal
  Future<void> _goToTheLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }
}
