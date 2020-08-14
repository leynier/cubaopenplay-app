import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  const ImageView(
    this.tag, {
    this.imageProvider,
  });

  final String tag;
  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height,
              ),
              child: PhotoView(
                imageProvider: imageProvider,
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                heroAttributes: PhotoViewHeroAttributes(tag: tag),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: EdgeInsets.only(right: 5, top: 15),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close, size: 25, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
