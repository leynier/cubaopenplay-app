import 'package:apklis_api/models/apklis_item_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cubaopenplay/src/pages/pages.dart';
import 'package:cubaopenplay/src/utils/utils.dart';
import 'package:cubaopenplay/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatelessWidget {
  final ApklisItemModel app;

  const DetailsPage({Key key, this.app}) : super(key: key);

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(Constants.appName),
      actions: <Widget>[
        PopupMenuButton<int>(
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<int>(
              value: 0,
              child: Text('Compartir'),
            ),
          ],
          onSelected: (index) {
            switch (index) {
              case 0:
                final prefix = 'https://www.apklis.cu/application/';
                final url = '$prefix${app.packageName}';
                Share.share(
                  'Descargue la aplicación de código abierto cubana '
                  '${app.name} desde Apklis.\n\n$url\n\n'
                  'Compartido por Cuba Open Play',
                );
                break;
            }
          },
        ),
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageView(
                      'img_${app.packageName}',
                      imageProvider: CachedNetworkImageProvider(
                        app.lastRelease.icon,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                child: Hero(
                  tag: 'img_${app.packageName}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: CachedNetworkImageProvider(
                        app.lastRelease.icon,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          app.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${app.developer.firstName} '
                          '${app.developer.lastName}',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          children: <Widget>[
                            Text(
                              app.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.star, size: 15),
                            SizedBox(width: 10),
                            Text(
                              app.downloadCount.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.file_download, size: 15),
                            SizedBox(width: 10),
                            Text(
                              app.lastRelease.versionName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      final prefix = 'https://www.apklis.cu/application/';
                      final url = '$prefix${app.packageName}';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        var snackBar = SnackBar(
                          content: Text('No se puede abrir.'),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    color: Theme.of(context).accentColor,
                    child: Text(
                      'Abrir en Apklis',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScreenshots(BuildContext context) {
    if (app.lastRelease.screenshots == null ||
        app.lastRelease.screenshots.length == 0) {
      return Container();
    }
    return Column(
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: app.lastRelease.screenshots.length,
            itemBuilder: (BuildContext context, int index) {
              var screenshot = app.lastRelease.screenshots[index];
              return GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: 100,
                  child: Hero(
                    tag: 'img_${app.packageName}_${screenshot.image}',
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: CachedNetworkImageProvider(
                        screenshot.image,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GalleryView(
                        initialIndex: index,
                        imageProviders: app.lastRelease.screenshots
                            .map((e) => CachedNetworkImageProvider(e.image))
                            .toList(),
                        tags: app.lastRelease.screenshots
                            .map(
                              (e) => 'img_${app.packageName}_${e.image}',
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            'Descripción:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Html(data: app.description),
        ),
      ],
    );
  }

  Widget buildVersion(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Text(
                'Versión:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(' ${app.lastRelease.versionName}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPublished(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Text(
                'Fecha:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(' ${app.lastRelease.published}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSize(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Text(
                'Tamaño:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(' ${app.lastRelease.size}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDownloads(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Text(
                'Cantidad de Descargas:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(' ${app.downloadCount}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAbi(BuildContext context) {
    if (app.lastRelease.abi == null || app.lastRelease.abi.length == 0) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            'Arquitectura${app.lastRelease.abi.length > 1 ? "s" : ""}:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              for (var abi in app.lastRelease.abi)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.all(1),
                  child: Text(abi.abi),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            'Categoría${app.categories.length > 1 ? "s" : ""}:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              for (var cat in app.categories)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.all(1),
                  child: Text(cat.name),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPermissions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            'Permiso${app.lastRelease.permissions.length > 1 ? "s" : ""}:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              for (var p in app.lastRelease.permissions)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.all(1),
                  child: Text(p.name),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMinimumVersion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          margin: EdgeInsets.all(10),
          child: Wrap(
            children: <Widget>[
              Text(
                'Versión mínima de Android:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(' ${app.lastRelease.versionSdkName}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRatings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Text(
                'Valoraciones:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(' ${app.reviewsCount}'),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    app.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '5',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                value: app.reviewsStar5 / app.reviewsCount,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '4',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                value: app.reviewsStar4 / app.reviewsCount,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '3',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                value: app.reviewsStar3 / app.reviewsCount,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '2',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                value: app.reviewsStar2 / app.reviewsCount,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '1',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                value: app.reviewsStar1 / app.reviewsCount,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildChangelog(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(thickness: 2, indent: 10, endIndent: 10),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            'Historial de Cambios:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Html(data: app.lastRelease.changelog),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: ListView(
          children: <Widget>[
            buildHeader(context),
            buildScreenshots(context),
            buildDescription(context),
            buildVersion(context),
            buildPublished(context),
            buildSize(context),
            buildDownloads(context),
            buildAbi(context),
            buildCategories(context),
            buildPermissions(context),
            buildMinimumVersion(context),
            buildRatings(context),
            buildChangelog(context),
          ],
        ),
      ),
    );
  }
}
