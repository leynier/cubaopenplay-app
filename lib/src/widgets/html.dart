import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:url_launcher/url_launcher.dart';

class Html extends StatelessWidget {
  final String data;

  const Html({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: html2md.convert(data),
      onTapLink: (url) async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          var snackBar = SnackBar(
            content: Text('No se puede abrir en enlace'),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    );
  }
}
