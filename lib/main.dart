import 'package:flutter/material.dart';
import 'page/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';

void main() {
  var counter = Counter();
  var providers = Providers();
  providers
    ..provide(Provider<Counter>.value(counter));

 // runApp(MyApp());
  runApp(ProviderNode(
    child: MyApp(),
    providers: providers,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false,  // 去除右上角Debug标签
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
      )
    );
  }
}