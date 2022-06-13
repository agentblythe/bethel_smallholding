abstract class Database {
  // CREATE , UPDATE , DELETE

  // READ

}

class FirestoreDatabase implements Database {
  final String uid;

  FirestoreDatabase({required this.uid});
}
