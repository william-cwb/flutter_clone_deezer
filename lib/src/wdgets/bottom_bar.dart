import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function onClick;

  const BottomBar({@required this.currentIndex, @required this.onClick});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      backgroundColor: Theme.of(context).accentColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        this.onClick(index);
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music),
          title: Text('Music'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mic),
          title: Text('Shows'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          title: Text('Favorites'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('Search'),
        ),
      ],
    );
  }
}
