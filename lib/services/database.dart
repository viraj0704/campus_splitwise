import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final db = FirebaseFirestore.instance;

  //  data is of the form amount: int, desc string?, paid_by: string
  Future addActivity(
      String paidBy, int amount, String? desc, String gid) async {
    db.collection('groups').doc(gid).collection('activity').add({
      'amount': amount,
      'desc': desc,
      'paid_by': paidBy,
    });
    db
        .collection('groups')
        .doc(gid)
        .collection('members')
        .doc(paidBy)
        .update({'contribution': FieldValue.increment(amount)});
  }

  Future CreateGroup(List<String> memberid) async {
    final newgroupRef = db.collection('groups').doc();
    for (var element in memberid) {
      db.collection('users').doc(element).get().then((DocumentSnapshot value) {
        final data = value.data() as Map<String, dynamic>;
        newgroupRef.collection('members').doc(element).set({
          'user_name': data['name'],
          'contribution': 0,
        });
      });
    }
    for (var element in memberid) {
      db.collection('user_grp').doc(element).update({newgroupRef.id: true});
    }
  }

  Future CreateUser(
      String uid, String email, String password, String name) async {
    db.collection('users').doc(uid).set({
      'email': email,
      'password': password,
      'name': name,
    });
  }
}
