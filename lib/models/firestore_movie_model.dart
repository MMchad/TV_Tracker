class FirestoreMovie {
  bool? listed;
  String? type;
  bool? watched;

  FirestoreMovie({this.listed, this.type, this.watched});

  FirestoreMovie.fromJson(Map<String, dynamic> json) {
    listed = json['Listed'];
    type = json['Type'];
    watched = json['Watched'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Listed'] = listed;
    data['Type'] = type;
    data['Watched'] = watched;
    return data;
  }
}
