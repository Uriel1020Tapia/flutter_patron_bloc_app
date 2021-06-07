import 'dart:convert';
import 'dart:io';

import 'package:flutter_app_patron_bloc/src/models/product_model.dart';
import 'package:flutter_app_patron_bloc/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductosProvider {
  final String _url = 'https://fluttervarios-app-default-rtdb.firebaseio.com';
  final prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductModel product) async {
    final url = '$_url/productos.json?auth=${prefs.token}';
    final resp =
        await http.post(Uri.parse(url), body: productModelToJson(product));
    final decodeData = json.decode(resp.body);
    print(decodeData);
    return true;
  }

  Future<bool> editarProducto(ProductModel product) async {
    final url = '$_url/productos/${product.id}.json?auth=${prefs.token}';
    final resp =
        await http.put(Uri.parse(url), body: productModelToJson(product));
    final decodeData = json.decode(resp.body);
    print(decodeData);
    return true;
  }

  Future<List<ProductModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${prefs.token}';
    final resp = await http.get(Uri.parse(url));
    final Map<String, dynamic> decodeData = json.decode(resp.body);
    final List<ProductModel> productos = [];

    if (decodeData == null) return [];

    if (decodeData['error'] != null) return [];

    decodeData.forEach((id, prod) {
      final prodTemp = ProductModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);
    });
    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${prefs.token}';
    final resp = await http.delete(Uri.parse(url));
    print(resp.body);

    return 1;
  }

  Future<String> subirImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dz9rsegvd/image/upload?upload_preset=zdl1dyyk');
    final mimeType = mime(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print("Algo salio mal");
      print(resp.body);
      return null;
    }
    final respData = json.decode(resp.body);
    print(respData['secure_url']);
    return respData['secure_url'];
  }
}
