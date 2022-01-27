import 'package:Cookbook/recipe.dart';
import 'package:Cookbook/recipeDatabase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class RecipeListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return RecipeListScreenState();
  }
}


class RecipeListScreenState extends State<RecipeListScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Recettes'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: RecipeDataBase.instance.recipes(),
        builder: (BuildContext context,AsyncSnapshot<List<Recipe>> snapshot){
          if(snapshot.hasData){

            List<Recipe>? recipes = snapshot.data;

            return ListView.builder(
                itemCount: recipes?.length,
                itemBuilder: (context,index){
                  final recipe = recipes![index];
                  return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction){
                        setState(() {
                          RecipeDataBase.instance.deleteRecipe(recipe.title);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${recipe.title} supprimé")));
                      },
                      background: Container(color: Colors.deepOrange),
                      child: RecipeItemWidget(recipe: recipe));
                });
          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }

}


class RecipeItemWidget extends StatelessWidget{
  const RecipeItemWidget({Key? key,required this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
            context,
            '/recipe',
            arguments: recipe
        );
      },
      child: Card(
          margin: EdgeInsets.all(8),
          elevation: 4,
          child:Row(
            children: [
              Hero(
                tag: "imageRecipe" + recipe.title,
                child: CachedNetworkImage(
                    imageUrl: recipe.imageUrl,
                    placeholder: (context,url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context,url,error) => Icon(Icons.error),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(recipe.title,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                    ),
                    Text(recipe.user, style: TextStyle(color: Colors.grey[500],fontSize: 16))
                  ],
                ),
              )
        ],
      )),
    );
  }

}