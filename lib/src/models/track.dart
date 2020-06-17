import 'package:flutterplayermusic/src/models/album.dart';
import 'package:flutterplayermusic/src/models/artist.dart';

class Track {
  int id;
  String title;
  String preview;
  Artist artist;
  Album album;

  Track({this.id, this.title, this.preview, this.artist, this.album});

  Track.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    preview = json['preview'];
    artist = Artist.fromJson(json['artist']);
    album = Album.fromJson(json['artist']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['preview'] = this.preview;
    data['artist'] = this.artist;
    data['album'] = this.album;
    return data;
  }
}
