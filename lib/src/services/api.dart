import 'dart:convert';

import 'package:flutterplayermusic/src/config/config.dart';
import 'package:flutterplayermusic/src/models/radio_genres.dart';
import 'package:flutterplayermusic/src/models/track.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<List<RadioGenre>> getRadiosAndGenres() async {
    final String url = '${Config.base_url}/radio/genres';
    final response = await http.get(url);
    Map data = json.decode(response.body);
    List<RadioGenre> radiosGenre = data['data']
        .map<RadioGenre>((data) => RadioGenre.fromJson(data))
        .toList();
    return radiosGenre;
  }

  static Future<List<Track>> getTracksFromRadiosAndGenres(int index) async {
    final String url = '${Config.base_url}/radio/$index/tracks';
    final response = await http.get(url);
    Map data = json.decode(response.body);
    List<Track> tracks =
        data['data'].map<Track>((data) => Track.fromJson(data)).toList();

    return tracks;
  }
}
