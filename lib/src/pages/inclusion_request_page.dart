import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InclusionRequestPage extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final linkSourceController = TextEditingController();
  final linkApklisController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Solicitar Inclusión'),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  'Para solicitar que se incluya una aplicación en Cuba Open '
                  'Play esta debe ser realizada por desarrolladores cubanos, '
                  'ser de código abierto y estar publicada en Apklis.',
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: linkSourceController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'Enlace del código fuente',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El enlace del código fuente es necesario';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: linkApklisController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'Enlace del app en Apklis',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El enlace del app en Apklis es necesario';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: FlatButton(
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    child: Text(
                      'Solicitar Inclusión',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (!formKey.currentState.validate()) {
                      return;
                    }
                    final email = 'codestrangeofficial@gmail.com';
                    final subject = 'Solicitud de Inclusión en Cuba Open Play';
                    final body = 'Solicitud de inclusión de una aplicación en '
                        '<strong>Cuba Open Play</strong>.'
                        '<br><br>'
                        'Código: ${linkSourceController.text.trim()}'
                        '<br><br>'
                        'Apklis: ${linkApklisController.text.trim()}';
                    final url = 'mailto:$email?subject=$subject&body=$body';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      log('Could not launch $url');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
