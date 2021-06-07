import 'package:flutter/material.dart';

import 'package:flutter_app_patron_bloc/src/bloc/login_bloc.dart';
export 'package:flutter_app_patron_bloc/src/bloc/login_bloc.dart';
import 'package:flutter_app_patron_bloc/src/bloc/productos_bloc.dart';
export 'package:flutter_app_patron_bloc/src/bloc/productos_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();
  final _productosBloc = ProductosBloc();
  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  // final loginBloc = LoginBloc();
  // Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(
    context,
  ) {
    final widget = context.dependOnInheritedWidgetOfExactType<Provider>();
    return widget.loginBloc;
  }

  static ProductosBloc productosBloc(
    context,
  ) {
    final widget = context.dependOnInheritedWidgetOfExactType<Provider>();
    return widget._productosBloc;
  }
}
