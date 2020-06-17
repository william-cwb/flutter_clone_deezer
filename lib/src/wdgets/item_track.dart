import 'package:flutter/material.dart';
import 'package:flutterplayermusic/src/models/track.dart';

class ItemTrack extends StatelessWidget {
  final Track track;
  final Function onClick;
  const ItemTrack({this.track, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ),
      height: 70,
      child: ListTile(
        leading: Icon(
          Icons.music_note,
          size: 25,
          color: Colors.white,
        ),
        onTap: () => onClick(track),
        title: Text(
          track.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          track.artist.name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border,
                size: 25,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_horiz,
                size: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildContainer() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10, left: 15, bottom: 5),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.music_note,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 230,
                          child: Text(
                            track.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          track.artist.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_border,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_horiz,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
