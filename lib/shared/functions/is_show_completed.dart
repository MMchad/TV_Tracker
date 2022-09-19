import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tv_tracker/models/appended_show_details.dart';
import 'package:tv_tracker/models/firestore_show.dart';
import 'package:tv_tracker/models/season.dart';
import 'package:tv_tracker/models/show_details_model.dart';

isCompleted(FirestoreShow firestoreShow, AppendedShowDetails show, List<Season> seasons) async {
  final ref = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
  var nbOfEpisodes = 0;
  for (Season season in seasons) {
    nbOfEpisodes += season.episodes!.length;
  }
  bool temp = nbOfEpisodes == firestoreShow.watched!.length;

  ref.doc("Tracking").get().then((snapshot) {
    Map<String, dynamic> tracking = snapshot.data() ?? {};
    if (temp) {
      tracking.remove(show.showDetails!.id.toString());
    } else {
      if (!tracking.containsKey(show.showDetails!.id.toString()) && firestoreShow.listed!) {
        tracking[show.showDetails!.id.toString()] = show.showDetails!.name!;
      }
    }
    ref.doc("Tracking").set(tracking);
  });
  if (firestoreShow.completed == temp) return;
  firestoreShow.completed = temp;
  ref.doc(show.showDetails!.id.toString()).set(firestoreShow.toJson());
}
