import 'package:Cookbook/recipe.dart';
import 'package:Cookbook/recipeListScreen.dart';
import 'package:Cookbook/recipeScreen.dart';
import 'package:flutter/material.dart';

//Point d'entrée de l'appli
void main() {
  runApp(MyApp());
}

//initialisation du widget principal
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cookbook',
      initialRoute: '/',
      onGenerateRoute: (settings)=> RouteGenerator.generateRoute( settings),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      )
    );
  }
}

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/' :
        return MaterialPageRoute(builder: (context)=> RecipeListScreen());
      case '/recipe':
        return PageRouteBuilder(
            pageBuilder:(context,Animation<double> animation, Animation<double> secondaryAnimation) => RecipeScreen(recipe: settings.arguments as Recipe),
            transitionsBuilder: (BuildContext context,Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return FadeTransition(
                  opacity: animation,
                  child: child
              );
            }
        );
      default:
        return MaterialPageRoute(
            builder: (context)=> Scaffold(
              appBar: AppBar(title: Text('Error'),centerTitle:true),
              body: Center(
                child: Text('Page not found')
              )
            )
        );
    }
  }
}