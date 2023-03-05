import 'package:realm/realm.dart';

part 'schemas.g.dart';

@RealmModel()
class _Item {
  @MapTo('_id')
  @PrimaryKey()
  late ObjectId id;
  bool isComplete = false;
  late String summary;
  @MapTo('owner_id')
  late String ownerId;
}

@RealmModel()
class _Lesson {
  @MapTo('_id')
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late List<ObjectId> topics;
}

@RealmModel()
class _Topic {
  @MapTo('_id')
  @PrimaryKey()
  late ObjectId id;
  late String title;
  late List<String> snippets;
  late List<ObjectId> questions;
}

@RealmModel()
class _Question {
  @MapTo('_id')
  @PrimaryKey()
  late ObjectId id;
  late List<String> answers;
  late String correctAnswer;
}
