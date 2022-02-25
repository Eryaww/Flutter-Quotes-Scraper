// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_quotes_scraper/quotes_page.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {

    final _contens = ['Quotes', 'About'];

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'All in One Tools',
            theme: ThemeData(
                colorScheme: const ColorScheme.light(
                    primary: Colors.orange,
                    secondary: Colors.purple,
                ),
            ),
            home: Scaffold(
                body: QuotesPage(),
            ),
        );
    }
}