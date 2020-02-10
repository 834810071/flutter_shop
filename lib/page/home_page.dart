import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';
import 'details_page/details_top_area.dart';

// 火爆专区
int page = 1;
List<Map> hotGoodsList = [];

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  String homePageContent = '正在获取数据';

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("百姓生活+"),
      ),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperDataList =
                (data['data']['slides'] as List).cast(); // 顶部轮播组件数
            List<Map> navigationList =
                (data['data']['category'] as List).cast(); // 列表类别
            String advertesPicture =
                data['data']['advertesPicture']['PICTURE_ADDRESS']; // 广告图片
            String leaderImage =
                data['data']['shopInfo']['leaderImage']; // 店长图片
            String leaderPhone = data['data']['shopInfo']['leaderPhone']; //店长电话
            List recommendList =
                (data['data']['recommend'] as List).cast(); // 商品推荐
            String floor1Title =
                data['data']['floor1Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
            String floor2Title =
                data['data']['floor2Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
            String floor3Title =
                data['data']['floor3Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
            List<Map> floor1 =
                (data['data']['floor1'] as List).cast(); //楼层1商品和图片
            List<Map> floor2 =
                (data['data']['floor2'] as List).cast(); //楼层1商品和图片
            List<Map> floor3 =
                (data['data']['floor3'] as List).cast(); //楼层1商品和图片
            return EasyRefresh(
              header: MaterialHeader(),
              footer: MaterialFooter(),
              child: ListView(
                children: <Widget>[
                  SwiperDiy(
                    swiperDataList: swiperDataList,
                  ),
                  TopNavigator(
                    navigatorList: navigationList,
                  ),
                  AdBanner(
                    advertesPicture: advertesPicture,
                  ),
                  LeaderPhone(
                    leaderImage: leaderImage,
                    leaderPhone: leaderPhone,
                  ),
                  Recomend(
                    recommendList: recommendList,
                  ),
                  FloorTitle(
                    picture_address: floor1Title,
                  ),
                  FloorContent(floorGoodsList: floor1),
                  FloorTitle(picture_address: floor2Title),
                  FloorContent(floorGoodsList: floor2),
                  FloorTitle(picture_address: floor3Title),
                  FloorContent(floorGoodsList: floor3),
                  HotGoods(),
                ],
              ),
              onLoad: () async {
                print("开始加载更多");
                var formData = {'page', page};
                request('homePageBelowConten', formData: formData).then((val) {
                  var data = json.decode(val.toString());
                  List<Map> newGoodsList = (data['data'] as List).cast();
                  setState(() {
                    hotGoodsList.addAll(newGoodsList);
                    ++page;
                  });
                });
              },
            );
          } else {
            return Center(
              child: Text("加载中"),
            );
          }
        },
      ),
    );
  }
}

// 首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    print('设备宽度:${ScreenUtil.screenWidth}');
    print('设备高度:${ScreenUtil.screenHeight}');
    print('设备像素密度:${ScreenUtil.pixelRatio}');
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                Application.router.navigateTo(context,"/detail?id=${swiperDataList[index]['goodsId']}");
              },
              child: Image.network("${swiperDataList[index]['image']}",
                  fit: BoxFit.fill));
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 导航单元素
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print("点击了导航");
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorList.length > 8) {
      navigatorList.removeRange(8, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(350),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: new NeverScrollableScrollPhysics(), // 固定
        crossAxisCount: 4,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewUI(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告图片
class AdBanner extends StatelessWidget {
  final String advertesPicture;

  AdBanner({Key key, this.advertesPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(advertesPicture);
  }
}

// 拨打电话 TODO 电话不跳转
class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  _launchURL() async {
    String url = 'tel:' + leaderPhone;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '不能打开 $url';
    }
  }
}

// 推荐商品
class Recomend extends StatelessWidget {
  final List recommendList;

  Recomend({Key key, this.recommendList}) : super(key: key);

  // 推荐商品标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        ),
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  Widget _item(index, context) {
    return InkWell(
        onTap: () {
          Application.router.navigateTo(context,"/detail?id=${recommendList[index]['goodsId']}");
        },
        child: Container(
          height: ScreenUtil().setHeight(330),
          width: ScreenUtil().setWidth(250),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(width: 1, color: Colors.black12),
              )),
          child: SingleChildScrollView(
            // TODO 屏幕溢出
            child: Column(
              children: <Widget>[
                Image.network(recommendList[index]['image']),
                Text('￥${recommendList[index]['mallPrice']}'),
                Text(
                  '￥${recommendList[index]['price']}',
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey),
                )
              ],
            ),
          ),
        ));
  }

  Widget _recommedList() {
    return Container(
      height: ScreenUtil().setWidth(330),
      child: ListView.builder(
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index, context);
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(380),
        margin: EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _titleWidget(),
              _recommedList(),
            ],
          ),
        ));
  }
}

// 楼层标题组件
class FloorTitle extends StatelessWidget {
  final String picture_address; // 图片地址

  FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

// 楼层商品组件
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  Widget _firstRow(context) {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0], context),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1], context),
            _goodsItem(floorGoodsList[2], context),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(context) {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3], context),
        _goodsItem(floorGoodsList[4], context),
      ],
    );
  }

  Widget _goodsItem(Map goods, context) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          //print("点击了楼层商品");
          Application.router.navigateTo(context, "/detail?id=${goods['goodsId']}");
        },
        child: Image.network(goods['image']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
//  int page = 1;
//  List<Map> hotGoodsList = [];

  // 火爆商品接口
  void _getHotGoods() {
    var formData = {'page', page};
    request('homePageBelowConten', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        ++page;
      });
    });
  }

  @override
  void initState() {
    super.initState();
//    getHomePageBelowContent().then((val) {
//      print(val);
//    });
    _getHotGoods();
  }

  // 火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        )),
    child: Text('火爆专区'),
  );

  // 火爆专区子项
  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {
            //print("点击了火爆商品");
            Application.router
                .navigateTo(context, "/detail?id=${val['goodsId']}");
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  val['image'],
                  width: ScreenUtil().setWidth(375),
                ),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: ScreenUtil().setSp(26),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text(' ');
    }
  }

  // 火爆专区组合
  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _hotGoods();
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

class MaterialHeader extends Header {
  final Key key;
  final double displacement;
  final Animation<Color> valueColor;
  final Color backgroundColor;

  final LinkHeaderNotifier linkNotifier = LinkHeaderNotifier();

  MaterialHeader({
    this.key,
    this.displacement = 40.0,
    this.valueColor,
    this.backgroundColor,
    completeDuration = const Duration(seconds: 1),
    bool enableHapticFeedback = false,
  }) : super(
          float: true,
          extent: 70.0,
          triggerDistance: 70.0,
          completeDuration: completeDuration == null
              ? Duration(
                  milliseconds: 300,
                )
              : completeDuration +
                  Duration(
                    milliseconds: 300,
                  ),
          enableInfiniteRefresh: false,
          enableHapticFeedback: enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    linkNotifier.contentBuilder(
        context,
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteRefresh,
        success,
        noMore);
    return MaterialHeaderWidget(
      key: key,
      displacement: displacement,
      valueColor: valueColor,
      backgroundColor: backgroundColor,
      linkNotifier: linkNotifier,
    );
  }
}
