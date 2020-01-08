
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webloginpage/responsive_helper.dart';

import 'api_services.dart';
import 'article_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  _fetchArticles() async {
    List<Article> articles =
        await APIService().fetchArticlesBySection('technology');
    setState(() {
      _articles = articles;
    });
  }

  _buildArticlesGrid(MediaQueryData mediaQuery) {
    List<GridTile> tiles = [];
    _articles.forEach((article) {
      tiles.add(_buildArticleTile(article, mediaQuery));
    });
    return Padding(
      padding: responsivePadding(mediaQuery),
      child: GridView.count(
        crossAxisCount: responsiveNumGridTiles(mediaQuery),
        mainAxisSpacing: 30.0,
        crossAxisSpacing: 30.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _buildArticleTile(Article article, MediaQueryData mediaQuery) {
    return GridTile(
      child: GestureDetector(
        onTap: () => _launchURL(article.url),
        child: Padding(
        padding: EdgeInsets.only(top: 20,bottom: 20),
        child: Container(
          height:responsiveImageHeight(mediaQuery),
          child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 4.0,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: responsiveImageHeight(mediaQuery),
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),          
                      ),
                      child: Image(
                        image: NetworkImage(article.imageUrl),
                        fit: BoxFit.cover,
                        ),
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          article.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff1089ff),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ],
           ),
          ),
        ),
      ),
    ),
  );
 }

            //child: Column(
            //children: <Widget>[
            // Container(
            //   height: responsiveImageHeight(mediaQuery),
            //   alignment: Alignment.bottomCenter,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(20.0),
            //       topRight: Radius.circular(20.0),
            //     ),
            //     image: DecorationImage(
            //       image: NetworkImage(article.imageUrl),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.all(10.0),
            //   alignment: Alignment.center,
            //   height: responsiveTitleHeight(mediaQuery),
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.only(
            //       bottomLeft: Radius.circular(20.0),
            //       bottomRight: Radius.circular(20.0),
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black12,
            //         offset: Offset(0, 1),
            //         blurRadius: 6.0,
            //       ),
            //     ],
            //   ),
            //   child: Text(
            //     article.title,
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 20.0,
            //       fontWeight: FontWeight.bold,
            //     ),
            //     maxLines: 2,
            //   ),
            // ),
          

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
           NavBar(mediaQuery: mediaQuery,),
           new SizedBox(
            height: 10.0,
            child: new Center(
              child: new Container(
                margin: new EdgeInsetsDirectional.only(start: 15.0, end: 15.0),
                height: 3.0,
                color: Colors.blue[900],
              ),
            ),
          ),
          _articles.length > 0
              ? _buildArticlesGrid(mediaQuery)
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}


class NavBar extends StatelessWidget {
  final MediaQueryData mediaQuery;
  const NavBar({Key key, this.mediaQuery}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var deviceWidth = mediaQuery.size.width;
      if(deviceWidth > 650.0){
      return Container(
            padding: EdgeInsets.only(left: 50,right:50),
            height: 150,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: GestureDetector(
                  child: Icon(
                    Icons.menu
                  ),
                  onTap: ()=>_showToast(context,'Menu option pressed'),
                ),
              ),
              Name(35,500),
              RaisedButton(
                color: Colors.redAccent,
                onPressed: (){
                  _showToast(context,'Nothing More');
                },
                child: Text('More',style: TextStyle(color: Colors.white),),
                )
            ],
            )
          );
         }
         else{
        return Container(
            padding:EdgeInsets.only(left: 10,right:10) ,
            height: 150,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                child: GestureDetector(
                  child: Icon(
                    Icons.menu
                  ),
                  onTap: ()=>_showToast(context,'Menu option pressed'),
                ),
              ),
              ),
              SizedBox(
                width: deviceWidth*0.15,
              ),
              Name(25,350),
            ],
            )
          );

      }
  }
}

class Name extends StatelessWidget {
  final double  x,y;
  Name(this.x,this.y);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: y,
      padding: EdgeInsets.only(top:50),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('The',textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: x,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.blue[800]
                ),),
              Text(' NEWYORK TIMES ',textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: x,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.black
                ),),
              Text('Top',textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: x,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.blue[800],
                ),),
            ],
          ),
          Text('Tech Articles',textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: x,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.blue[800]
                ),),
        ],
      ),
    );
  }
}

void _showToast(BuildContext context,String text) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
        content: Text(text),
        action: SnackBarAction(
            label: 'UNDO' , textColor: Colors.white,onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
            
