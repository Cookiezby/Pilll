import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';

part 'pill.codegen.g.dart';
part 'pill.codegen.freezed.dart';

class PillFirestoreKey {
  static const String typeInfo = "typeInfo";
  static const String createdAt = "createdAt";
  static const String deletedAt = "deletedAt";
  static const String lastPillTakenDate = "lastPillTakenDate";
  static const String beginingDate = "beginingDate";
}

@freezed
class PillTaken with _$PillTaken {
  @JsonSerializable(explicitToJson: true)
  const factory PillTaken({
    // 同時服用を行った場合は対象となるPillTakenのtakenDateTimeは同一にする
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime takenDateTime,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime createdDateTime,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime updatedDateTime,
    // backendで自動的に記録された場合にtrue
    @Default(false) bool isAutomaticallyRecorded,
  }) = _PillTaken;

  factory PillTaken.fromJson(Map<String, dynamic> json) => _$PillTakenFromJson(json);
}

@freezed
class Pill with _$Pill {
  const Pill._();
  @JsonSerializable(explicitToJson: true)
  const factory Pill(
      {required int index,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      required DateTime createdDateTime,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      required DateTime updatedDateTime,
      required List<PillTaken> pillTakens}) = _Pill;

  factory Pill.fromJson(Map<String, dynamic> json) => _$PillFromJson(json);

  static List<Pill> generateAndFillTo({
    required PillSheetType pillSheetType,
    required DateTime fromDate,
    required DateTime? lastTakenDate,
    required int pillTakenCount,
  }) {
    return List.generate(pillSheetType.totalCount, (index) {
      final date = fromDate.add(Duration(days: index));
      return Pill(
        index: index,
        createdDateTime: now(),
        updatedDateTime: now(),
        pillTakens: lastTakenDate != null && (date.isBefore(lastTakenDate) || isSameDay(date, lastTakenDate))
            ? List.generate(
                pillTakenCount,
                (i) {
                  // 本来であればlastTakenDateよりも前の日付のピルもlastTakenDateで上書きする。本来の日付のロジックにもできるが、lastTakenDateで上書きした方がユニットテストが簡単なのでそうしている
                  return PillTaken(takenDateTime: lastTakenDate, createdDateTime: now(), updatedDateTime: now());
                },
              )
            : [],
      );
    });
  }
}
