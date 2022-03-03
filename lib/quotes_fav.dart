import 'package:flutter/material.dart';
import 'package:flutter_quotes_scraper/api.dart';
import 'package:flutter_quotes_scraper/quotes_page.dart';

class Fav extends StatefulWidget {
    final Set<Quote> _fav;
    
    const Fav(this._fav);

    @override
    _favState createState() => _favState();
}

class _favState extends State<Fav>{

    @override
    void initState(){
        super.initState();
    }
    
    Widget _tile(Quote quote){
        return InkWell(
            child: Column(
                children: <Widget>[
                    Row(
                        children: <Widget>[
                            Expanded(
                                child: ListTile(
                                    title: Text(quote.text),
                                )
                            ),
                            Text(quote.author, style: const TextStyle(fontSize: 15, ),),
                            const VerticalDivider(),
                            const Icon(
                                Icons.favorite,
                                color: Colors.red,
                            ),
                        ],
                    ),
                    Row(
                        children: tagsRow(quote),
                    ),
                ],
            ),
            onTap: (){
                setState(() {
                    widget._fav.remove(quote);
                });
            },
        );
    }

    @override
    Widget build(BuildContext context) {

        final Iterable<Widget> fav = widget._fav.map((quote) => _tile(quote));
        final List<Widget> _finalFav = ListTile.divideTiles(context: context, tiles: fav).toList();
        return Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                        Navigator.pop(context, widget._fav);
                    }
                ),
                title: const Text('Favorite Quote'),
                backgroundColor: Colors.green,
            ),
            body: ListView(children: _finalFav,),
        );
    }
}