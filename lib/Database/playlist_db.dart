class PlaylistFolder{
  int? id;
  String playListName;

  PlaylistFolder({ this.id, required this.playListName});

  PlaylistFolder.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        playListName = res['playListName'];


  Map<String,dynamic> toMapForDB(){
    return {
      'id':id,
      'playListName':playListName,
    };
  }

}