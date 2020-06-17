import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterplayermusic/src/blocs/player_bloc.dart';
import 'package:flutterplayermusic/src/models/menu_item.dart';
import 'package:flutterplayermusic/src/models/radios.dart';
import 'package:flutterplayermusic/src/models/track.dart';
import 'package:flutterplayermusic/src/services/api.dart';

import 'package:flutterplayermusic/src/views/tabs/favorites.dart';
import 'package:flutterplayermusic/src/views/tabs/music.dart';
import 'package:flutterplayermusic/src/views/tabs/search.dart';
import 'package:flutterplayermusic/src/views/tabs/shows.dart';

import 'package:flutterplayermusic/src/wdgets/bottom_bar.dart';
import 'package:flutterplayermusic/src/wdgets/item_track.dart';
import 'package:flutterplayermusic/src/wdgets/sliver_custom_appbar.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with TickerProviderStateMixin<IndexPage> {
  int _currentIndex = 0;
  List<MenuItem> _listPages = [];
  double displayW = 0.0;
  double displayH = 0.0;
  bool isShowBottomPlayer = false;
  AnimationController _animationController;
  Animation<double> _heightPlayerOpened;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioCache audioCache = AudioCache();
  bool isPlaying = false;
  PageController _pageController;
  int currentIndexPageView = 0;
  Radios radioSelected;
  List<Track> tracks = [];
  String urlTrack = '';
  Track trackSelected;
  PlayerBloc _playerBloc;

  @override
  void initState() {
    super.initState();

    _playerBloc = new PlayerBloc();
    _pageController = new PageController(initialPage: 0);

    audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      double value = duration.inSeconds.toDouble();
      _playerBloc.sinkPlayer.add(value);
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      _playerBloc.sinkPlayerState.add(PlayerBloc.STOPPED);
    });

    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      audioPlayer.startHeadlessService();
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.addListener(() {
      setState(() {
        double valueAnimation = _heightPlayerOpened.value.round().toDouble();
        final double dividerQuery = displayH * 0.89;
        if (valueAnimation >= dividerQuery) {
          isShowBottomPlayer = true;
        } else {
          isShowBottomPlayer = false;
        }
      });
    });

    _listPages.add(
      new MenuItem(
        title: 'Music',
        widget: MusicTab(
          pageController: _pageController,
          onClick: _onClickRadio,
        ),
      ),
    );
    _listPages.add(
      new MenuItem(
        title: 'Shows',
        widget: ShowsTab(),
      ),
    );
    _listPages.add(
      new MenuItem(
        title: 'Favorites',
        widget: FavoritesTab(),
      ),
    );
    _listPages.add(
      new MenuItem(
        title: 'Search',
        widget: SearchTab(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    displayW = MediaQuery.of(context).size.width;
    displayH = MediaQuery.of(context).size.height;

    _heightPlayerOpened = new Tween<double>(
      begin: 0.0,
      end: displayH,
    ).animate(
      _animationController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onClick: _onClickTab,
      ),
      body: PageView(
        controller: _pageController,
//        physics: CustomScroll(),
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                height: 100,
                width: displayW,
                child: Text(
                  _listPages.elementAt(_currentIndex).title,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Container(
                height: displayH * 0.74,
                child: _listPages.elementAt(_currentIndex).widget,
              ),
            ],
          ),
          Container(
            child: _buildPageDetails(),
          ),
        ],
      ),
      floatingActionButton:
          isShowBottomPlayer ? _buildBottomPlayer() : _buildPlayerOpened(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _onClickTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _buildBottomPlayer() {
    // bottom 84;
    return GestureDetector(
      onTap: () {
        _animationController.reverse();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 51),
        height: 50,
        color: Theme.of(context).accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildLeftIcons(),
            _buildRightIcons(),
          ],
        ),
      ),
    );
  }

  _buildPlayerOpened() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 10) {
          _animationController.forward();
        }
      },
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: _heightPlayerOpened.value),
          height: displayH,
          width: displayW,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          color: Theme.of(context).accentColor,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: displayH * 0.10,
                child: IconButton(
                  onPressed: () {
                    _animationController.forward();
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                height: 350,
                child: Image.network(
                  "https://e-cdns-images.dzcdn.net/images/artist/7a66231b65ed2a4040991bf5730c4826/1000x1000-000000-80-0-0.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: _getIcon(
                        Icons.share,
                        size: 30,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          width: 1.0,
                          color: Colors.white,
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: _getIcon(
                        Icons.favorite_border,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('00:00'),
                    Text('05:00'),
                  ],
                ),
              ),
              StreamBuilder<double>(
                initialData: 0.0,
                stream: _playerBloc.streamPlayer,
                builder: (context, snapshot) {
                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                      trackHeight: 3,
                      thumbColor: Colors.grey[300],
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                      value: snapshot.data,
                      min: 0,
                      max: 30,
                      onChanged: (value) {},
                    ),
                  );
                },
              ),
              Text(
                trackSelected?.title ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                trackSelected?.artist?.name ?? '',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              _buildButtons(),
              SizedBox(height: 10),
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Audio Settings',
          ),
          Text(
            'Queue list',
          ),
        ],
      ),
    );
  }

  _buildButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: _getIcon(Icons.replay, size: 20),
            onPressed: () {},
          ),
          Center(
            child: _buildButtonsPlayer(),
          ),
          IconButton(
            icon: _getIcon(Icons.shuffle, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  _buildButtonsPlayer() {
    return Container(
      width: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: IconButton(
              icon: _getIcon(Icons.skip_previous),
              onPressed: () {},
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: IconButton(
              icon: StreamBuilder<int>(
                initialData: PlayerBloc.STOPPED,
                stream: _playerBloc.streamPlayerState,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == PlayerBloc.PLAYING)
                    return _getIcon(Icons.pause);
                  else if (snapshot.data == PlayerBloc.LOADING) {
                    return Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    );
                  } else {
                    return _getIcon(Icons.play_arrow);
                  }
                },
              ),

              // StreamBuilder<double>(
              //   initialData: 0.0,
              //   stream: _playerBloc.streamPlayer,
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     if (snapshot.data == 0.0 || snapshot.data == null)
              //       return _getIcon(
              //         Icons.play_arrow,
              //         size: 45,
              //       );

              //     if (snapshot.data > 0.0)
              //       return _getIcon(
              //         Icons.pause,
              //         size: 45,
              //       );
              //   },
              // ),
              onPressed: () {},
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: IconButton(
              icon: _getIcon(Icons.skip_next),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  _buildLeftIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            print('on click play');
          },
          child: StreamBuilder<int>(
            initialData: PlayerBloc.STOPPED,
            stream: _playerBloc.streamPlayerState,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == PlayerBloc.PLAYING)
                return _getIcon(Icons.pause);
              else if (snapshot.data == PlayerBloc.LOADING) {
                return Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
              } else {
                return _getIcon(Icons.play_arrow);
              }
            },
          ),
        ),
        SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              trackSelected?.title ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(trackSelected?.artist?.name ?? ''),
          ],
        )
      ],
    );
  }

  _buildRightIcons() {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            print('on Click Favorite');
          },
          child: _getIcon(
            Icons.favorite_border,
            size: 30,
          ),
        ),
        SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            print('on Click Next');
          },
          child: _getIcon(
            Icons.skip_next,
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }

  _buildPageDetails() {
    return Stack(
      children: <Widget>[
        CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: SliverCustomAppBar(
                displayH * 0.40,
                radioSelected != null
                    ? radioSelected.pictureBig
                    : 'https://via.placeholder.com/150',
                radioSelected != null ? radioSelected.title : '',
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 40),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ItemTrack(
                      track: tracks[index],
                      onClick: _onClickTrack,
                    );
                  },
                  childCount: tracks.length,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _onClickRadio(Radios radio) async {
    radioSelected = radio;
    tracks = await Api.getTracksFromRadiosAndGenres(radio.id);
    setState(() {});
    _jumpPage(1);
  }

  _getIcon(IconData icon, {double size = 35, Color color = Colors.white}) {
    return Icon(
      icon,
      color: color,
      size: size,
    );
  }

  play() async {
    _playerBloc.sinkPlayerState.add(PlayerBloc.LOADING);
    int result = await audioPlayer.play(urlTrack, isLocal: false);
    if (result == 1) {
      _playerBloc.sinkPlayerState.add(PlayerBloc.PLAYING);
    } else {
      _playerBloc.sinkPlayerState.add(PlayerBloc.STOPPED);
    }
  }

  _jumpPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  _buildActionsButtonSliver() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildButtonSliver(
          _getIcon(
            Icons.share,
            size: 25,
            color: Theme.of(context).accentIconTheme.color,
          ),
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
              _getIcon(Icons.play_arrow),
              Text(
                'PLAY SHUFFLE',
                style: TextStyle(letterSpacing: 1),
              ),
              SizedBox(width: 2),
            ],
          ),
        ),
        _buildButtonSliver(
          _getIcon(
            Icons.favorite_border,
            size: 25,
            color: Theme.of(context).accentIconTheme.color,
          ),
        ),
      ],
    );
  }

  _buildButtonSliver(Icon icon) {
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

  _onClickTrack(Track track) {
    trackSelected = track;
    if (track.preview != null) {
      urlTrack = track.preview;
      play();
      setState(() {
        isPlaying = !isPlaying;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _playerBloc.dispose();
  }
}
