import 'package:flutter/material.dart';
import 'package:flutter_shop/page/category_page.dart';
import 'page/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import 'provide/child_category.dart';
import 'provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import 'routers/routes.dart';
import 'routers/application.dart';
import 'provide/details_info.dart';

void main() {
  var counter = Counter();
  var providers = Providers();
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailInfoProvide = DetailsInfoProvide();
  providers
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
    ..provide(Provider<DetailsInfoProvide>.value(detailInfoProvide));
 // runApp(MyApp());
  runApp(ProviderNode(
    child: MyApp(),
    providers: providers,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false,  // 去除右上角Debug标签
        onGenerateRoute:  Application.router.generator,
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
      )
    );
  }
}