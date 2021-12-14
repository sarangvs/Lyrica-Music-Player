class User {
  int num;
  String name;

  String location;

  User({
    required this.num,
    required this.name,
    required this.location,
  });

  User.fromMap(Map<String, dynamic> res)
      : num = res['num'],
        name = res['name'],
        location = res['location'];

  Map<String, Object?> toMap() {
    return {
      'num': num,
      'name': name,
      'location': location,
    };
  }
}
