import 'package:flutter/material.dart';
import 'package:flutterplayermusic/src/models/radio_genres.dart';
import 'package:flutterplayermusic/src/models/radios.dart';
import 'package:flutterplayermusic/src/services/api.dart';

class MusicTab extends StatefulWidget {
  final PageController pageController;
  final Function onClick;

  const MusicTab({@required this.pageController, @required this.onClick});

  @override
  _MusicTabState createState() => _MusicTabState();
}

class _MusicTabState extends State<MusicTab>
    with AutomaticKeepAliveClientMixin<MusicTab> {
  @override
  bool get wantKeepAlive => true;

  Radios radioSelected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<List<RadioGenre>>(
      future: Api.getRadiosAndGenres(),
      builder: (BuildContext context, AsyncSnapshot data) {
        if (data.hasError) {
          return Center(
            child: Text('Falha ao carregar'),
          );
        }
        if (!data.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (data.hasData) {
          return _buildBody(data.data);
        }
      },
    );
  }

  _buildBody(List<RadioGenre> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, index) {
        final RadioGenre radioGenre = data.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitle(radioGenre.title),
            _buildListHorizontal(radioGenre.radios),
          ],
        );
      },
    );
  }

  _buildListHorizontal(List<Radios> radios) {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 20, left: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: radios.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          final Radios radio = radios.elementAt(index);
          return GestureDetector(
            onTap: () {
              widget.onClick(radio);
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                    image: NetworkImage(radio.pictureMedium),
                    fit: BoxFit.cover),
              ),
              width: 160,
            ),
          );
        },
      ),
    );
  }

  _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
