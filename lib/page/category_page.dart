import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../models/category.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../models/categoryGoodsList.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      // print(data);
      CategoryModel list = CategoryModel.fromJson(data);
      // list.data.forEach((item) => print(item.mallCategoryName));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("商品分类")),
      body: Container(
//        width: ScreenUtil().setWidth(750),
//        height: ScreenUtil().setHeight(1334),
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            SingleChildScrollView(
                child: Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

//左侧导航菜单
class LeftCategoryNav extends StatefulWidget {
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0; //索引

  @override
  void initState() {
    //print(0);
    _getCategory();
    super.initState();
  }

  void _getCategory() async {
    //print(1);
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      //print(data);
      CategoryModel category = CategoryModel.fromJson(data);
      // list.data.forEach((item) => print(item.mallCategoryName));
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto, '4'); // TODO list[0].mallCategoryId

      //print(list[0].bxMallSubDto);
      list[0].bxMallSubDto.forEach((item) => print(item.mallSubName));
    });
  }

  Widget _leftInkWel(int index) {
    //print(2);
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;

    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;

        Provide.value<ChildCategory>(context)
            .getChildCategory(childList, categoryId);
        _getGoodList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
            color: isClick ? Color.fromRGBO(236, 238, 239, 1.0) : Colors.white,
            border: Border(
              bottom: BorderSide(width: 1, color: Colors.black12),
            )),
        child: Text(list[index].mallCategoryName,
            style: TextStyle(fontSize: ScreenUtil().setSp(28))),
      ),
    );
  }

  void _getGoodList({String categoryId}) async {
    //print(3);
    //print("categoryId == $categoryId");
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': "",
      'page': 1
    };
    //print("左边发送的data" + data.toString());
//    var data = {'categoryId': '4', 'categorySubId': "", 'page': 1};
    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context)
          .getGoodsList(goodsList.data);

      //print('分类商品列表：>>>>>>>>>>>>>${data}');
      //print('>>>>>>>>>>>>>>>>>>>:${list[0].goodsName}');
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(4);
    //print("左边");
    //_getGoodList();
    //print("啊啊啊" + list.length.toString());
    return Container(
      width: ScreenUtil().setWidth(150),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _leftInkWel(index);
          }),
    );
  }
}

// 右侧小类类别
class RightCategoryNav extends StatefulWidget {
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  // List list = ['名酒', '宝丰', '北京二锅头'];

  Widget _rightInkWell(int index, BxMallSubDto item) {
    //print(5);
    bool isCheck = false;
    isCheck = (index == Provide.value<ChildCategory>(context).childIndex)
        ? true
        : false;

    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context)
            .changeChildIndex(index, item.mallSubId);
        _getGoodList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(item.mallSubName,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: isCheck ? Colors.pink : Colors.black)),
      ),
    );
  }

  //得到商品列表数据
  void _getGoodList(String categorySubId) {
    //print(6);
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    //print("发送的数据:" + data.toString());

    request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      print(data);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      // Provide.value<CategoryGoodsList>(context).getGoodsList(goodsList.data);
      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getGoodsList(goodsList.data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(7);
    //print("右边");
    return Container(child: Provide<ChildCategory>(
      builder: (context, child, childCategory) {
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _rightInkWell(
                  index, childCategory.childCategoryList[index]);
            },
            itemCount: childCategory.childCategoryList.length,
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    ));
  }
}

//商品列表，可以上拉加载

class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  List<CategoryListData> list = [];

//  void _getGoodList({String categoryId}) async {
//
//    var data = {'categoryId': '4', 'categorySubId': "", 'page': 1};
//    await request('getMallGoods', formData: data).then((val) {
//      var data = json.decode(val.toString());
//      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
//      setState(() {
//        list = goodsList.data;
//      });
//      //print('分类商品列表：>>>>>>>>>>>>>${data}');
//      print('>>>>>>>>>>>>>>>>>>>:${list[0].goodsName}');
//    });
//  }

  Widget _goodsImage(List newList, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList, index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List newList, index) {
    return Container(
        margin: EdgeInsets.only(top: 20.0),
        width: ScreenUtil().setWidth(370),
        child: Row(children: <Widget>[
          Text(
            '价格:￥${newList[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '￥${newList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ]));
  }

  Widget _ListWidget(List newList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
              width: 1.0,
              color: Colors.black12,
            ))),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 上拉加载更多的方法
  void _getMoreList() {
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };

    request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);

      if (goodsList.data == null) {
        Provide.value<ChildCategory>(context).changeNoMore('没有更多了');
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .addGoodsList(goodsList.data);
      }
    });
  }

  var scrollController=new ScrollController();

  @override
  Widget build(BuildContext context) {
    //_getCategory();
    return Provide<CategoryGoodsListProvide>(

      builder: (context, child, data) {
        try {
          if (Provide.value<ChildCategory>(context).page == 1) {
            scrollController.jumpTo(0.0);
          }
        } catch (e) {
          print("第一次进入初始化页面$e");
        }
        if (data.goodsList.length > 0) {
          return Container(
              width: ScreenUtil().setWidth(570),
              height: ScreenUtil().setHeight(1000),
              child: EasyRefresh(
                  footer: MaterialFooter(),
                  child: ListView.builder(
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      //print(data.goodsList.length);
                      return _ListWidget(data.goodsList, index);
                    },
                    itemCount: data.goodsList.length,
                  ),
                  onLoad: () async {
                    if (Provide.value<ChildCategory>(context).noMoreText ==
                        '没有更多了') {
                      Fluttertoast.showToast(
                          msg: "已经到底了",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.pink,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    } else {
                      _getMoreList();
                    }
                  }
                  ));
        } else {
          return Text("暂时没有数据");
        }
      },
    );
  }
}

class MaterialFooter extends Footer {
  final Key key;
  final double displacement;
  final Animation<Color> valueColor;
  final Color backgroundColor;

  final LinkFooterNotifier linkNotifier = LinkFooterNotifier();

  MaterialFooter({
    this.key,
    this.displacement = 40.0,
    this.valueColor,
    this.backgroundColor,
    completeDuration = const Duration(seconds: 1),
    bool enableHapticFeedback = false,
    bool enableInfiniteLoad = true,
  }) : super(
          float: true,
          extent: 52.0,
          triggerDistance: 52.0,
          completeDuration: completeDuration == null
              ? Duration(
                  milliseconds: 300,
                )
              : completeDuration +
                  Duration(
                    milliseconds: 300,
                  ),
          enableHapticFeedback: enableHapticFeedback,
          enableInfiniteLoad: enableInfiniteLoad,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    linkNotifier.contentBuilder(
        context,
        loadState,
        pulledExtent,
        loadTriggerPullDistance,
        loadIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteLoad,
        success,
        noMore);
    return MaterialFooterWidget(
      key: key,
      displacement: displacement,
      valueColor: valueColor,
      backgroundColor: backgroundColor,
      linkNotifier: linkNotifier,
    );
  }
}
