class FirestoreShow {
  String? showName;
  bool? listed;
  String? type;
  List<String>? watched;
  bool? completed;
  int? watchedLength;
  FirestoreShow({this.listed, this.type, this.watched, this.completed, this.watchedLength, this.showName});

  FirestoreShow.fromJson(Map<String, dynamic> json) {
    listed = json['Listed'];
    type = json['Type'];
    watched = json['Watched'].cast<String>();
    completed = json['Completed'];
    watchedLength = json['Watched Length'];
    showName = json['Show Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Listed'] = listed;
    data['Type'] = type;
    data['Watched'] = watched;
    data['Completed'] = completed;
    data['Watched Length'] = watchedLength;
    data['Show Name'] = showName;
    return data;
  }
}
