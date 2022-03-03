import 'dart:convert';
import 'package:http/http.dart' as http;

const endpoint = 'http://192.168.1.100:8080/';

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

Future<List<Quote>> fetchQuote(int page) async {
    final response = await http.get(
        Uri.parse(endpoint+page.toString()),
        headers: {
            'Accept': 'application/json',
        },
    );
    if(response.statusCode == 200){
        final data = json.decode(response.body);
        final quotes = data as List;
        return quotes.map((e) => Quote.fromJson(e)).toList();
    }else{
        throw Exception('Failed to fetch API');
    }
}