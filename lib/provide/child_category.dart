import 'package:flutter/material.dart';
import '../models/category.dart';

// ChangeNotifier的混入是不用管理听众
class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0;
  String categoryId = '4';  // 大类的ID
  String subId = '';  // 小类ID
  int page=1;  //列表页数，当改变大类或者小类时进行改变
  String noMoreText=''; //显示更多的标识

  // 点击大类更换
  getChildCategory(List<BxMallSubDto> list, String id) {
    //print("啊啊啊");
    childIndex = 0;
    categoryId = id;
    subId = '';
    page = 1;
    noMoreText = '';
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = ''; // 返回全部没有数据
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  // 改变子类索引
  changeChildIndex(index, String id) {
    //print("恩恩额");
    childIndex = index;
    subId = id;
    page = 1;
    noMoreText = '';
    notifyListeners();
  }

  addPage() {
    ++page;
  }

  //改变noMoreText数据
  changeNoMore(String text){
    noMoreText=text;
    notifyListeners();
  }
//  getChildCategory(List list) {
//    childCategoryList = list;
//    notifyListeners();
//  }

}
