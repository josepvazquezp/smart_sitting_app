import 'package:mongo_dart/mongo_dart.dart';

const MONGO_URL =
    "mongodb+srv://demo:jokeis123@myapp.cezdi1f.mongodb.net/smart_sitting?retryWrites=true&w=majority";

const COLLECTION = "smart_sitting_data";

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_URL);
    await db.open();
    print(db);
    userCollection = db.collection(COLLECTION);
  }
}
