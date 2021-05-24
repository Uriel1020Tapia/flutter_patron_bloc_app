import 'package:flutter/material.dart';
import 'package:flutter_app_patron_bloc/src/bloc/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [_cretaBg(context), _loginForm(context)],
    ));
  }

  Widget _cretaBg(context) {
    final size = MediaQuery.of(context).size;

    final bgPurple = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    return Stack(
      children: [
        bgPurple,
        Positioned(
          child: createCircle(50.0, 50.0),
          top: 90.0,
          left: 30.0,
        ),
        Positioned(
          child: createCircle(70.0, 70.0),
          top: -10.0,
          right: 50.0,
        ),
        Positioned(
          child: createCircle(100.0, 100.0),
          bottom: -50.0,
          right: -10.0,
        ),
        Positioned(
          child: createCircle(60.0, 60.0),
          bottom: 140.0,
          right: 50.0,
        ),
        Positioned(
          child: createCircle(100.0, 100.0),
          bottom: -10.0,
          left: -20.0,
        ),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              SizedBox(
                height: 20.0,
                width: double.infinity,
              ),
              Text(
                'FLUTTER APP',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget createCircle(width, height) {
    final circle = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.08)),
    );

    return circle;
  }

  Widget _loginForm(context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: 250.0,
          )),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 20.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _createEmail(bloc),
                SizedBox(height: 30.0),
                _createPassword(bloc),
                SizedBox(height: 30.0),
                _createButton(bloc)
              ],
            ),
          ),
          Text('¿Olvido la contraseña?'),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _createEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon:
                    Icon(Icons.alternate_email, color: Colors.deepPurpleAccent),
                hintText: 'example@mail.com',
                labelText: 'Correo electrónico',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _createPassword(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (context, AsyncSnapshot snapshot) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline,
                        color: Colors.deepPurpleAccent),
                    labelText: 'Contraseña',
                    counterText: snapshot.data,
                    errorText: snapshot.error),
                onChanged: bloc.changePassword,
              ));
        });
  }

  Widget _createButton(LoginBloc bloc) {
    //formValidStream
    final ButtonStyle style = ElevatedButton.styleFrom(
      primary: Colors.deepPurpleAccent,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(0.05),
      ),
      onPrimary: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    );

    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (context, AsyncSnapshot snapshot) {
          return ElevatedButton(
              style: style,
              child: Text('Ingresar'),
              onPressed: snapshot.hasData ? () => _login(bloc, context) : null);
        });
  }

  _login(LoginBloc bloc, BuildContext context) {
    print('================');
    print('Email: ${bloc.email}');
    print('Password: ${bloc.password}');
    print('================');

    Navigator.pushReplacementNamed(context, 'home');
  }
}
