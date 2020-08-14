import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:apklis_api/apklis_api.dart';
import 'package:cubaopenplay/src/pages/details_page.dart';
import 'package:cubaopenplay/src/pages/image_view.dart';
import 'package:cubaopenplay/src/utils/app_theme.dart';
import 'package:cubaopenplay/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(Constants.appName),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
          drawer: Drawer(
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      DrawerHeader(
                        child: Container(
                          child: Image.asset(Constants.appLogo),
                          padding: EdgeInsets.all(20),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ThemeSwitcher(
                      builder: (context) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          child: IconButton(
                            onPressed: () {
                              ThemeSwitcher.of(context).changeTheme(
                                theme: ThemeProvider.of(context).brightness ==
                                        Brightness.light
                                    ? AppTheme.dark
                                    : AppTheme.light,
                              );
                            },
                            icon: Icon(Icons.brightness_3, size: 25),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: FutureBuilder(
            future: ApklisApi().get([
              'club.postdata.covid19cuba',
              'com.codestrange.www.cuba_weather',
              'com.cubanopensource.todo',
              'cu.todus.android',
              'cu.uci.android.apklis',
              'cu.etecsa.cubacel.tr.tm',
              'cu.xetid.apk.enzona',
              'cu.sitrans.viajando',
              'cu.miimpulso.mialerta',
              'cu.picta.android',
            ]),
            builder: (BuildContext context,
                AsyncSnapshot<ApklisApiResult> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.isOk) {
                  return ListView(
                    children: <Widget>[
                      SizedBox(height: 10),
                      for (var app
                          in snapshot.data.result.results
                            ..sort((a, b) => a.name.compareTo(b.name)))
                        Container(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageView(
                                      'img_${app.packageName}',
                                      imageProvider:
                                          NetworkImage(app.lastRelease.icon),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                child: Hero(
                                  tag: 'img_${app.packageName}',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: app.lastRelease.icon,
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            isThreeLine: true,
                            title: Text(
                              app.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${app.developer.firstName} '
                                  '${app.developer.lastName}',
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(app.rating.toStringAsFixed(1)),
                                    Icon(Icons.star, size: 15),
                                    SizedBox(width: 10),
                                    Text(app.downloadCount.toString()),
                                    Icon(Icons.file_download, size: 15),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(app: app),
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 10),
                    ],
                  );
                } else {
                  return Center(
                    child: Text(snapshot.data.error),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
