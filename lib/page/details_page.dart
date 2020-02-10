import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
import 'details_page/details_top_area.dart';
import 'details_page/details_explaiin.dart';

class DetailsPage extends StatelessWidget {

  final String goodsId;

  DetailsPage({Key key, this.goodsId}) : super(key: key);

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    print("加载完成........");
  }

  @override
  Widget build(BuildContext context) {
    _getBackInfo(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print("返回上一页");
            Navigator.pop(context);
          },
        ),
        title: Text('商品详细页'),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: <Widget>[
                  DetailTopArea(),
                  DetailsExplain(),
                ],
              ),
            );
          } else {
            return Text("加载中.......");
          }
        },
      ),
    );
  }
}