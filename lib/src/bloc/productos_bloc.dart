import 'dart:io';

import 'package:flutter_app_patron_bloc/src/models/product_model.dart';
import 'package:flutter_app_patron_bloc/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final _productoController = new BehaviorSubject<List<ProductModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosPrvider = new ProductosProvider();

  Stream<List<ProductModel>> get productosStream => _productoController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void cargarProductos() async {
    final productos = await _productosPrvider.cargarProductos();
    _productoController.sink.add(productos);
  }

  void agregarProducto(ProductModel producto) async {
    _cargandoController.sink.add(true);
    await _productosPrvider.crearProducto(producto);
    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto(File image) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosPrvider.subirImage(image);
    _cargandoController.sink.add(false);

    return fotoUrl;
  }

  void editarProducto(ProductModel producto) async {
    _cargandoController.sink.add(true);
    await _productosPrvider.editarProducto(producto);
    _cargandoController.sink.add(false);
  }

  void borrarProducto(String id) async {
    await _productosPrvider.borrarProducto(id);
  }

  dispose() {
    _productoController.close();
    _cargandoController.close();
  }
}
