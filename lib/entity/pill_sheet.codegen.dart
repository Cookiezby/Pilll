import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'pill_sheet.codegen.g.dart';
part 'pill_sheet.codegen.freezed.dart';

class PillSheetFirestoreKey {
  static final String typeInfo = "typeInfo";
  static final String createdAt = "createdAt";
  static final String deletedAt = "deletedAt";
  static final String lastTakenDate = "lastTakenDate";
  static final String beginingDate = "beginingDate";
}

@freezed
class PillSheetTypeInfo with _$PillSheetTypeInfo {
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetTypeInfo({
    required String pillSheetTypeReferencePath,
    required String name,
    required int totalCount,
    required int dosingPeriod,
  }) = _PillSheetTypeInfo;

  factory PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$PillSheetTypeInfoFromJson(json);
}

@freezed
class RestDuration with _$RestDuration {
  @JsonSerializable(explicitToJson: true)
  const factory RestDuration({
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? endDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdDate,
  }) = _RestDuration;

  factory RestDuration.fromJson(Map<String, dynamic> json) =>
      _$RestDurationFromJson(json);
}

@freezed
class PillSheet with _$PillSheet {
  String? get documentID => id;

  PillSheetType get sheetType =>
      PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);

  const PillSheet._();
  @JsonSerializable(explicitToJson: true)
  const factory PillSheet({
    @JsonKey(includeIfNull: false)
        String? id,
    @JsonKey()
        required PillSheetTypeInfo typeInfo,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime beginingDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? lastTakenDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? deletedAt,
    @Default(0)
        int groupIndex,
    @Default([])
        List<RestDuration> restDurations,
  }) = _PillSheet;
  factory PillSheet.create(PillSheetType type) => PillSheet(
        typeInfo: type.typeInfo,
        beginingDate: today(),
        lastTakenDate: null,
      );

  factory PillSheet.fromJson(Map<String, dynamic> json) =>
      _$PillSheetFromJson(json);

  PillSheetType get pillSheetType =>
      PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);

  int get todayPillNumber {
    return daysBetween(beginingDate.date(), today()) -
        summarizedRestDuration(
            restDurations: restDurations, upperDate: today()) +
        1;
  }

  // NOTE: if pill sheet is not yet taken, lastTakenNumber return 0;
  // Because if lastTakenPillNumber is nullable, ! = null, making it difficult to compare.
  // lastTakenNumber is often compare todayPillNumber
  int get lastTakenPillNumber {
    final lastTakenDate = this.lastTakenDate;
    if (lastTakenDate == null) {
      return 0;
    }

    final lastTakenPillNumber =
        daysBetween(beginingDate.date(), lastTakenDate.date()) + 1;
    if (restDurations.isEmpty) {
      return lastTakenPillNumber;
    }

    final summarizedRestDuration = restDurations.map((e) {
      if (!lastTakenDate.isAfter(e.beginDate)) {
        // ignore summarized
        return 0;
      }
      final endDate = e.endDate;
      if (endDate == null) {
        // when lastTakenDate.isAfter(e.beginDate) and endDate is not null is unexpected pattern
        assert(false);
        return 0;
      }

      return daysBetween(e.beginDate, endDate);
    }).reduce((value, element) => value + element);

    return lastTakenPillNumber - summarizedRestDuration;
  }

  bool get todayPillIsAlreadyTaken => todayPillNumber == lastTakenPillNumber;
  bool get isEnded => typeInfo.totalCount == lastTakenPillNumber;
  bool get isBegan =>
      beginingDate.date().toUtc().millisecondsSinceEpoch <
      now().toUtc().millisecondsSinceEpoch;
  bool get inNotTakenDuration => todayPillNumber > typeInfo.dosingPeriod;
  bool get pillSheetHasRestOrFakeDuration =>
      !pillSheetType.isNotExistsNotTakenDuration;
  bool get isActive {
    final n = now();
    final begin = beginingDate.date();
    final totalCount = typeInfo.totalCount;
    final end = begin.add(Duration(
        days: totalCount +
            summarizedRestDuration(
                restDurations: restDurations, upperDate: today()) -
            1));
    return DateRange(begin, end).inRange(n);
  }

  DateTime get estimatedLastTakenDate => beginingDate
      .add(Duration(days: pillSheetType.totalCount - 1))
      .add(Duration(
          days: summarizedRestDuration(
              restDurations: restDurations, upperDate: today())))
      .date()
      .add(const Duration(days: 1))
      .subtract(const Duration(seconds: 1));

  RestDuration? get activeRestDuration {
    if (restDurations.isEmpty) {
      return null;
    } else {
      if (restDurations.last.endDate == null &&
          restDurations.last.beginDate.isBefore(now())) {
        return restDurations.last;
      } else {
        return null;
      }
    }
  }

  DateTime displayPillTakeDate(int pillNumberIntoPillSheet) {
    final originDate =
        beginingDate.add(Duration(days: pillNumberIntoPillSheet - 1)).date();

    if (restDurations.isEmpty) {
      return originDate;
    }

    final distance = restDurations.fold(0, (int result, restDuration) {
      final beginDate = restDuration.beginDate.date();
      final endDate = restDuration.endDate?.date();

      if (endDate != null && isSameDay(beginDate, endDate)) {
        return result;
      }
      if (originDate.isBefore(beginDate)) {
        return result;
      }

      if (endDate != null) {
        return result + daysBetween(beginDate, endDate);
      } else {
        return result + daysBetween(beginDate, today());
      }
    });

    return originDate.add(Duration(days: distance));
  }
}

// upperDate is assumed to be lastTakenDate(when calculate lastTakenPillNumber) or today(when calculate todayPillNumber).
int summarizedRestDuration({
  required List<RestDuration> restDurations,
  required DateTime upperDate,
}) {
  if (restDurations.isEmpty) {
    return 0;
  }
  return restDurations.map((e) {
    if (!upperDate.isAfter(e.beginDate)) {
      // ignore summarized
      return 0;
    }
    final endDate = e.endDate;
    if (endDate == null) {
      return daysBetween(e.beginDate, today());
    }

    return daysBetween(e.beginDate, endDate);
  }).reduce((value, element) => value + element);
}

int? pillSheetPillNumber(
    {required PillSheet pillSheet, required DateTime? targetDate}) {
  if (targetDate == null) {
    return null;
  }

  return daysBetween(pillSheet.beginingDate.date(), targetDate) -
      summarizedRestDuration(
          restDurations: pillSheet.restDurations, upperDate: targetDate) +
      1;
}
