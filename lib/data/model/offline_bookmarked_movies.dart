import 'dart:convert';

import 'package:movie_app/data/model/hive_offline_bookmarked_movies.dart';

OfflineBookmarkedModel offlineBookmarkedModelFromJson(String str) =>
    OfflineBookmarkedModel.fromJson(json.decode(str));

String offlineBookmarkedModelToJson(OfflineBookmarkedModel data) =>
    json.encode(data.toJson());

class OfflineBookmarkedModel {
  int? id;
  bool? isBookmarked;

  OfflineBookmarkedModel({this.id, this.isBookmarked});

  factory OfflineBookmarkedModel.fromJson(Map<String, dynamic> json) =>
      OfflineBookmarkedModel(
        id: json["id"],
        isBookmarked: json["isBookmarked"],
      );

  Map<String, dynamic> toJson() => {"id": id, "isBookmarked": isBookmarked};
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OfflineBookmarkedModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
  @override
  String toString() {
    return 'OfflineBookmarkedModel(id: $id, isBookmarked: $isBookmarked)';
  }
}

extension OfflineBookmarkToHive on OfflineBookmarkedModel {
  OfflineBookmarkedHiveModel toHiveModel() {
    return OfflineBookmarkedHiveModel(id: id, isBookmarked: isBookmarked);
  }
}

extension HiveToOfflineBookmark on OfflineBookmarkedHiveModel {
  OfflineBookmarkedModel toOriginalModel() {
    return OfflineBookmarkedModel(id: id, isBookmarked: isBookmarked);
  }
}
