import 'package:flutter/material.dart';
import 'package:flutter_app_patron_bloc/src/bloc/provider.dart';
import 'package:flutter_app_patron_bloc/src/models/product_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     Text('Email: ${bloc.email}'),
      //     Divider(),
      //     Text('Password: ${bloc.password}')
      //   ],
      // ),
      body: _crearListado(productosBloc),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _crearListado(ProductosBloc productoBloc) {
    return StreamBuilder(
        stream: productoBloc.productosStream,
        builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            final productos = snapshot.data;
            return ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, i) =>
                    _crearItem(context, productoBloc, productos[i]));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _crearItem(
      context, ProductosBloc productoBloc, ProductModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            productoBloc.borrarProducto(producto.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Borrado"),
                duration: Duration(milliseconds: 3000),
              ),
            );
          } else {
            print("no eliminado");
          }
        },
        child: Card(
          child: Column(
            children: [
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      image: NetworkImage(producto.fotoUrl),
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover),
              ListTile(
                title: Text('${producto.title} - ${producto.value}'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'product',
                    arguments: producto),
              )
            ],
          ),
        ));
  }

  Widget _createButton(context) {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'product'),
      child: Icon(Icons.add),
    );
  }
}
