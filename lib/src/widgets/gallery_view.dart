import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryView extends StatefulWidget {
  final int initialIndex;
  final List<ImageProvider> imageProviders;
  final List<String> tags;
  final PageController pageController;

  GalleryView({
    Key key,
    this.initialIndex,
    this.imageProviders,
    this.tags,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

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
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.imageProviders.length,
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
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
                  icon: Icon(Icons.close, color: Colors.white, size: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final imageProvider = widget.imageProviders[index];
    final tag = widget.tags[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: imageProvider,
      heroAttributes: PhotoViewHeroAttributes(tag: tag),
    );
  }
}
