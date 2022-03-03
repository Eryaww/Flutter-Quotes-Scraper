import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

const endpoint = 'http://192.168.1.100:8080/';

final LocalStorage storage = LocalStorage('app');

class Quote{
    final String text;
    final String author;
    final List<String> tags;

    Quote({
        required this.text,
        required this.author,
        required this.tags,
    });

    factory Quote.fromJson(Map<String, dynamic> json){
        return Quote(
            text: json['quote'], 
            author: json['author'], 
            tags: (json['tags'] as List).map((e) => e as String).toList(),
        );
    }

    @override
    operator ==(other){
        return other is Quote &&
            other.text == text &&
            other.author == author &&
            other.tags == tags;
    }
}

List<Quote> fromLocalStorage(int page) {
    if (storage.getItem(page.toString()) == null){
        return [];
    }
    return storage.getItem(page.toString());
}

Future<List<Quote>> fetchQuote(int page) async {
    final localItem = fromLocalStorage(page);
    if(localItem.isNotEmpty){
        return localItem;
    }
    
    final response = await http.get(
        Uri.parse(endpoint+page.toString()),
        headers: {
            'Accept': 'application/json',
        },
    );
    if(response.statusCode == 200){
        final data = json.decode(response.body);
        final quotes = data as List;
        final returnData = quotes.map((e) => Quote.fromJson(e)).toList();
        storage.setItem(page.toString(), returnData);
        return returnData;
    }else{
        throw Exception('Failed to fetch API');
    }
}