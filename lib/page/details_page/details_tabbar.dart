import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';

class DetailsTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsTabbar> (
      builder: (context, child, val) {

      }
    );
  }

  Widget _myTabBarLeft(BuildContext context, bool isLeft) {
    return InkWell (
      onTap: () {
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isLeft ? Colors.pink : Colors.black12
            )
          )
        ),
        child: Text(
          '详细',
          style: TextStyle(color: isLeft ? Colors.pink : Colors.black),
        )
      ),
    );
  }

  Widget _myTabBarRight(BuildContext context, bool isRight) {
    return InkWell (
      onTap: () {
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('left');
      },
      child: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(375),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(
                      width: 1.0,
                      color: isRight ? Colors.pink : Colors.black12
                  )
              )
          ),
          child: Text(
            '详细',
            style: TextStyle(color: isRight ? Colors.pink : Colors.black),
          )
      ),
    );
  }
}
