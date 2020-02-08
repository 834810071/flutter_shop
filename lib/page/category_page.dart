import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../models/category.dart';

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
    //_getCategory();
    return Scaffold(
      body: Center(
        child: LeftCategoryNav(),
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

  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      //print(data);
      CategoryModel category = CategoryModel.fromJson(data);
      // list.data.forEach((item) => print(item.mallCategoryName));
      setState(() {
        list = category.data;
      });
      print(list.length);
    });
  }

  Widget _leftInkWel(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 1, color: Colors.black12),
            )),
        child: Text(list[index].mallCategoryName,
            style: TextStyle(fontSize: ScreenUtil().setSp(28))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftInkWel(index);
        }
      ),
    );
  }
}
