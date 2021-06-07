import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_patron_bloc/src/bloc/provider.dart';
import 'package:flutter_app_patron_bloc/src/models/product_model.dart';
// import 'package:flutter_app_patron_bloc/src/providers/products_provider.dart';
import 'package:flutter_app_patron_bloc/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  // final productosProvider = new ProductosProvider();

  ProductosBloc productosBloc;

  ProductModel product = new ProductModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      product = prodData;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _tomarFoto)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  _mostrarFoto(),
                  _createName(),
                  _createPrice(),
                  _createDisbonible(),
                  _createButton()
                ],
              )),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Nombre'),
      onSaved: (value) => product.title = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => product.value = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo se permiten números';
        }
      },
    );
  }

  Widget _createButton() {
    final ButtonStyle style = ElevatedButton.styleFrom(
      primary: Colors.deepPurpleAccent,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(0.05),
      ),
      onPrimary: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    );

    return ElevatedButton.icon(
        icon: Icon(
          Icons.save,
          color: Colors.white,
          size: 24.0,
        ),
        label: Text('Guardar'),
        onPressed: (_guardando) ? null : _submit,
        style: style);
  }

  Widget _createDisbonible() {
    return SwitchListTile(
      value: product.active,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        product.active = value;
      }),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      product.fotoUrl = await productosBloc.subirFoto(foto);
    }
    if (product.id == null) {
      productosBloc.agregarProducto(product);
    } else {
      productosBloc.editarProducto(product);
    }
    // setState(() {
    //   _guardando = false;
    // });
    showSnackBar("Guardado correctamente");
    Navigator.pop(context);
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
        content: Text(message),
        backgroundColor: Colors.deepPurpleAccent,
        // behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 3000));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _mostrarFoto() {
    if (product.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(product.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300,
        fit: BoxFit.cover,
      );
    }
  }

  Future _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  void _tomarFoto() {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: origen);

    foto = File(pickedFile.path);

    if (foto != null) {
      product.fotoUrl = null;
    }
    setState(() {});
  }
}
