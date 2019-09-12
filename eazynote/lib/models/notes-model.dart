class NotesModel {
 dynamic id;
 String title;
 String subtitle;
 String category;
 String dateTime;
 String userId;
 int isLocal;

  NotesModel({this.id, this.title, this.subtitle, this.category, this.dateTime, this.userId, this.isLocal});

    // SQLFLITE DATABASE

    // String get id => id;
    // String get title => title;
    // String get subtitle => subtitle;
    // String get category => category;
    // String get dateTime => dateTime;
    // String get userId => userId;


  factory NotesModel.fromJson(Map<String, dynamic> json) {
  return NotesModel(
      id: json["id"],
      title: json["title"],
      subtitle: json["subtitle"],
      category: json["category"],
      dateTime: json["dateTime"],
      isLocal: json["isLocal"]
  );}

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "title": title,
  //     "subtitle": subtitle,
  //     "category": category,
  //     "dateTime": dateTime
  // };
}
