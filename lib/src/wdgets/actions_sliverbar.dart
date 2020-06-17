import 'package:flutter/material.dart';

class ActionsSliver extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      child: _buildActionsButtonSliver(context),
    );
  }

  _buildActionsButtonSliver(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildButtonSliver(
          Icon(
            Icons.share,
            size: 25,
            color: Theme.of(context).accentIconTheme.color,
          ),
          context,
        ),
        Container(
          width: 180,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).accentIconTheme.color,
            borderRadius: BorderRadius.circular(60),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              Text(
                'PLAY SHUFFLE',
                style: TextStyle(letterSpacing: 1),
              ),
              SizedBox(width: 2),
            ],
          ),
        ),
        _buildButtonSliver(
          Icon(
            Icons.favorite_border,
            size: 25,
            color: Theme.of(context).accentIconTheme.color,
          ),
          context,
        ),
      ],
    );
  }

  _buildButtonSliver(Icon icon, BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
      ),
      child: icon,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(80);
}
