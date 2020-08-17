import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:apklis_api/models/apklis_item_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cubaopenplay/src/blocs/blocs.dart';
import 'package:cubaopenplay/src/pages/pages.dart';
import 'package:cubaopenplay/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatelessWidget {
  final showDialogToDonate;

  const HomePage(this.showDialogToDonate);

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(Constants.appName),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            GetIt.I.get<IAppsBloc>().add(FetchAppsEvent());
          },
        ),
      ],
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
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
                ListTile(
                  title: Text('Donar'),
                  leading: Icon(Icons.card_giftcard),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonatePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Configuraciones'),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
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
                        DataManager.appTheme =
                            ThemeProvider.of(context).brightness ==
                                    Brightness.light
                                ? AppThemeType.dark
                                : AppThemeType.light;
                        ThemeSwitcher.of(context).changeTheme(
                          theme: DataManager.appTheme.theme,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<IAppsBloc>()..add(FetchAppsEvent()),
      child: ThemeSwitchingArea(
        child: SafeArea(
          child: Scaffold(
            appBar: buildAppBar(context),
            drawer: buildDrawer(context),
            body: HomeWidget(showDialogToDonate),
          ),
        ),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  final showDialogToDonate;

  const HomeWidget(this.showDialogToDonate);

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  Completer<void> refreshCompleter;
  var firstTime = true;

  @override
  void initState() {
    super.initState();
    refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IAppsBloc, AppsState>(
      listener: (BuildContext context, AppsState state) {
        if (state is ErrorAppsState && state.cacheModel != null) {
          var snackBar = SnackBar(
            content: Text(
              '${state.errorMessage}\n\n${Constants.lastInfoMessage}',
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
        if (state is CorrectAppsState || state is ErrorAppsState) {
          refreshCompleter?.complete();
          refreshCompleter = Completer();
        }
        if (state is CorrectAppsState) {
          if (firstTime && widget.showDialogToDonate) {
            firstTime = false;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Donar'),
                  content: Container(
                    child: Text(
                      'Esta aplicación es gratuita y lo seguirá siendo. La '
                      'intención es dar a conocer las aplicaciones cubanas de '
                      'código abierto.\n\n'
                      'Si lo desea, puede ayudar a que el proyecto siga '
                      'creciendo realizando una donación. Cualquier '
                      'contribución, por pequeña que sea, nos permitirá '
                      'dedicarle más tiempo y recursos a la aplicación.\n\n'
                      'Muchas gracias de antemano.',
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No donar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Donar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DonatePage(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      builder: (BuildContext context, AppsState state) {
        return RefreshIndicator(
          onRefresh: () {
            BlocProvider.of<IAppsBloc>(context).add(RefreshAppsEvent());
            return refreshCompleter.future;
          },
          child: Builder(
            builder: (context) {
              if (state is LoadingAppsState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ErrorAppsState) {
                if (state.cacheModel == null) {
                  return ListView(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      Container(
                        margin: EdgeInsets.all(30),
                        child: Center(
                          child: Text(
                            state.errorMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListView(
                    children: <Widget>[
                      SizedBox(height: 10),
                      for (var model in state.cacheModel.results)
                        buildApklisItem(context, model),
                      SizedBox(height: 10),
                    ],
                  );
                }
              } else if (state is CorrectAppsState) {
                return ListView(
                  children: <Widget>[
                    SizedBox(height: 10),
                    for (var model in state.data)
                      buildApklisItem(context, model),
                    SizedBox(height: 10),
                  ],
                );
              }
              return Container();
            },
          ),
        );
      },
    );
  }

  Widget buildApklisItem(BuildContext context, ApklisItemModel model) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageView(
                  'img_${model.packageName}',
                  imageProvider: CachedNetworkImageProvider(
                    model.lastRelease.icon,
                  ),
                ),
              ),
            );
          },
          child: Container(
            child: Hero(
              tag: 'img_${model.packageName}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: CachedNetworkImageProvider(
                    model.lastRelease.icon,
                  ),
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ),
        isThreeLine: true,
        title: Text(
          model.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${model.developer.firstName} '
              '${model.developer.lastName}',
            ),
            Row(
              children: <Widget>[
                Text(model.rating.toStringAsFixed(1)),
                Icon(Icons.star, size: 15),
                SizedBox(width: 10),
                Text(model.downloadCount.toString()),
                Icon(Icons.file_download, size: 15),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(app: model),
            ),
          );
        },
      ),
    );
  }
}
