class PlaylistSongs {
  int? id;
  int songID;
  int playlistID;
  String songName;
  String path;

  PlaylistSongs(
      {this.id,
      required this.songID,
      required this.playlistID,
      required this.songName,
      required this.path});

  PlaylistSongs.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        songID = res['songID'],
        playlistID = res['playlistID'],
        songName = res['songName'],
        path = res['path'];

  Map<String, dynamic> toMapForDB() {
    return {
      'id': id,
      'songID': songID,
      'playlistID': playlistID,
      'songName': songName,
      'path': path,
    };
  }
}
