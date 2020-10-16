import 'dart:ui';

import 'package:FireBaseDemo/blocs/authentications_bloc.dart';
import 'package:FireBaseDemo/events/authentication_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is Homepage'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationEventLoggedOut());
              })
        ],
      ),
      body: Center(
        child: Text('This is home page', style: TextStyle(fontSize: 22,color: Colors.green),),
      ),
    );
  }
}
