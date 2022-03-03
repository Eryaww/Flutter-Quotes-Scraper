import 'package:flutter/material.dart';
import 'package:flutter_quotes_scraper/quotes_fav.dart';
import 'package:flutter_quotes_scraper/api.dart';
import 'package:universal_html/html.dart';

class QuotesPage extends StatefulWidget {
    @override
    _QuotesPageState createState() => _QuotesPageState();
}

List<Widget> tagsRow(Quote quote){
    final List<Widget> _listTags = quote.tags.map((tag) => 
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
                color: Colors.lightGreen,
            ),
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            margin: const EdgeInsets.only(bottom: 6),
            child: Text(tag, style: const TextStyle(fontSize: 12, color: Colors.white),),
        ) as Widget
    ).toList();
    for(var i = _listTags.length-1; i>=0; i--){
        _listTags.insert(i, const VerticalDivider());
    }
    return _listTags;
}

class _QuotesPageState extends State<QuotesPage> {

    late Future<List<Quote>> _quote;
    var _fav = Set<Quote>();
    var page = 1;

    @override
    void initState() {
        super.initState();
        _quote = fetchQuote(page);
    }

    Widget _buildQuotes(AsyncSnapshot<List<Quote>> snapshot){
        return ListView.builder(
            itemCount: 2*snapshot.data!.length,
            itemBuilder: (context, index) {
                if(index.isOdd) return Divider();
                final i = index ~/ 2;
                return _tile(snapshot.data![i], i);
            }
        );
    }

    Widget _buildSuggestions() {
        return FutureBuilder <List<Quote>>(
            future: _quote,
            builder: (context, snapshot){
                if(snapshot.hasData){
                    return _buildQuotes(snapshot);
                }else if (snapshot.hasError){
                    return Text("${snapshot.error}");
                }
                return const Center(child: CircularProgressIndicator(),);
            },
        );
    }

    Widget _tile(Quote quote, int index){
        var _alreadyFav = false;
        for (var item in _fav){
            if(item.text == quote.text){
                _alreadyFav = true;
                break;
            }
        }
        // if(index == 1){
        //     if(_fav.isNotEmpty){
        //         print(_fav.first.text);
        //     }
        //     print(_alreadyFav);
        // }
        final tags = tagsRow(quote);
        return InkWell(
            child: 
                Column(
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
                                Icon(
                                    _alreadyFav ? Icons.favorite : Icons.favorite_border,
                                    color: _alreadyFav ? Colors.red : null,
                                ),
                            ],
                        ),
                        SizedBox(
                            height: 32.5,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: tags,
                            ),
                        )
                    ],
                ),
            onTap: (){
                setState(() {
                    if(_alreadyFav){
                        for(var item in _fav){
                            if(item.text == quote.text){
                                _fav.remove(item);
                                break;
                            }
                        }
                    }else{
                        _fav.add(quote);
                    }
                });
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Quotes Generator'),
                actions: <Widget>[
                    IconButton(icon: Icon(Icons.navigate_before), onPressed: (){
                        setState((){
                            if(page > 1){
                                page--;
                            }
                            _quote = fetchQuote(page);
                        });
                    }),
                    IconButton(icon: Icon(Icons.navigate_next), onPressed: (){
                        setState((){
                            page++;
                            _quote = fetchQuote(page);
                        });
                    }),
                    IconButton(icon: const Icon(Icons.list), onPressed: () async {
                        final _returnData = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                            return Fav(_fav);
                            }),
                        );
                        setState(() {
                            _fav = _returnData as Set<Quote>;
                        });
                    })
                ],
            ),
            body: _buildSuggestions(),
        );
    }
}