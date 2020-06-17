import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'actions_sliverbar.dart';

class SliverCustomAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String url;
  final String title;
  SliverCustomAppBar(this.expandedHeight, this.url, this.title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double value1 = expandedHeight / 2;
    double value2 = shrinkOffset / value1;
    double value4 = (1 - value2);
    value4 = value4.isNegative ? 0.0 : value4;

    return Container(
      color: Theme.of(context).accentColor,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20),
                Visibility(
                  visible: shrinkOffset < 132,
                  child: Opacity(
                    opacity: value4,
                    child: CircleAvatar(
                      radius: 90,
                      backgroundImage: NetworkImage(url),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: shrinkOffset < 100,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ActionsSliver(),
            ),
          ),
        ],
      ),
    );
    ;
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
