import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';

part 'pilll_ads.codegen.freezed.dart';
part 'pilll_ads.codegen.g.dart';

@freezed
class PilllAds with _$PilllAds {
  @JsonSerializable(explicitToJson: true)
  factory PilllAds({
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime startDateTime,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime endDateTime,
    required String description,
    required String? imageURL,
    required String destinationURL,
    required String hexColor,
    // このフィールドの値よりパッケージバージョンが高い場合には、広告を表示する。
    // なので最も低いバージョンをデフォルト値としている
    @Default("0.0.0") String version,
  }) = _PilllAds;
  PilllAds._();

  factory PilllAds.fromJson(Map<String, dynamic> json) => _$PilllAdsFromJson(json);
}
