import 'package:hive/hive.dart';
part 'hive_offline_bookmarked_movies.g.dart';

@HiveType(typeId: 5)
class OfflineBookmarkedHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  bool? isBookmarked;

  OfflineBookmarkedHiveModel({this.id, this.isBookmarked});
}
