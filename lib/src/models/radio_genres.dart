import 'package:flutterplayermusic/src/models/radios.dart';

class RadioGenre {
  int id;
  String title;
  List<Radios> radios;

  RadioGenre({this.id, this.title, this.radios});

  RadioGenre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    radios =
        json['radios'].map<Radios>((data) => Radios.fromJson(data)).toList();
  }
}
