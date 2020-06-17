import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class PlayerBloc {
  static final int PLAYING = 0;
  static final int STOPPED = 1;
  static final int LOADING = 2;
  static final int RESUME = 4;
  static final int COMPLETED = 5;
  static final currentState = 1;

  static final PlayerBloc _instance = PlayerBloc.internal();
  factory PlayerBloc() => _instance;
  PlayerBloc.internal();

  final StreamController _controllerPlayer =
      new StreamController<double>.broadcast();
  Stream get streamPlayer => _controllerPlayer.stream;
  Sink get sinkPlayer => _controllerPlayer.sink;

  final StreamController _controllerPlayerState =
      new StreamController<int>.broadcast();
  Stream get streamPlayerState => _controllerPlayerState.stream;
  Sink get sinkPlayerState => _controllerPlayerState.sink;

  void dispose() {
    _controllerPlayer.close();
    _controllerPlayerState.close();
  }
}
