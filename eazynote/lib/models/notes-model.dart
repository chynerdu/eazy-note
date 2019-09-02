class NotesModel {
 String id;
 String title;
 String subtitle;
 String category;
 String dateTime;
 String userId;

  NotesModel({this.id, this.title, this.subtitle, this.category, this.dateTime, this.userId});

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
      dateTime: json["dateTime"]
  );}

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "title": title,
  //     "subtitle": subtitle,
  //     "category": category,
  //     "dateTime": dateTime
  // };
}