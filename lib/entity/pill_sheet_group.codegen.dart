import 'package:pilll/entity/firestore_document_id_escaping_to_json.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pill_sheet_group.codegen.g.dart';
part 'pill_sheet_group.codegen.freezed.dart';

class PillSheetGroupFirestoreKeys {
  static final createdAt = "createdAt";
}

@freezed
class PillSheetGroup with _$PillSheetGroup {
  const PillSheetGroup._();
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetGroup({
    @JsonKey(includeIfNull: false, toJson: toNull)
        String? id,
    required List<String> pillSheetIDs,
    required List<PillSheet> pillSheets,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? deletedAt,
    OffsetPillNumber? offsetPillNumber,
  }) = _PillSheetGroup;

  factory PillSheetGroup.fromJson(Map<String, dynamic> json) =>
      _$PillSheetGroupFromJson(json);

  PillSheet? get activedPillSheet {
    final filtered = pillSheets.where((element) => element.isActive);
    return filtered.isEmpty ? null : filtered.first;
  }

  PillSheetGroup replaced(PillSheet pillSheet) {
    if (pillSheet.id == null) {
      throw const FormatException("ピルシートの置き換えによる更新できませんでした");
    }
    final index =
        pillSheets.indexWhere((element) => element.id == pillSheet.id);
    if (index == -1) {
      throw FormatException("ピルシートの置き換えによる更新できませんでした。id: ${pillSheet.id}");
    }
    final copied = [...pillSheets];
    copied[index] = pillSheet;
    return copyWith(pillSheets: copied);
  }

  bool get _isDeleted => deletedAt != null;
  bool get isDeactived => activedPillSheet == null || _isDeleted;

  int get sequentialTodayPillNumber {
    if (pillSheets.isEmpty) {
      return 0;
    }
    final activedPillSheet = this.activedPillSheet;
    if (activedPillSheet == null) {
      return 0;
    }

    final passedPillSheets = pillSheets.sublist(0, activedPillSheet.groupIndex);
    final passedPillCountForPillSheetTypes =
        summarizedPillSheetTypeTotalCountToPageIndex(
            pillSheetTypes:
                passedPillSheets.map((e) => e.pillSheetType).toList(),
            pageIndex: activedPillSheet.groupIndex);

    var sequentialTodayPillNumber =
        passedPillCountForPillSheetTypes + activedPillSheet.todayPillNumber;

    final offsetPillNumber = this.offsetPillNumber;
    if (offsetPillNumber != null) {
      final beginPillNumberOffset = offsetPillNumber.beginPillNumber;
      if (beginPillNumberOffset != null) {
        sequentialTodayPillNumber += (beginPillNumberOffset - 1);
      }

      final endPillNumberOffset = offsetPillNumber.endPillNumber;
      if (endPillNumberOffset != null) {
        sequentialTodayPillNumber %= endPillNumberOffset;
        if (sequentialTodayPillNumber == 0) {
          sequentialTodayPillNumber = endPillNumberOffset;
        }
      }
    }

    return sequentialTodayPillNumber;
  }

  int get sequentialLastTakenPillNumber {
    if (pillSheets.isEmpty) {
      return 0;
    }
    final activedPillSheet = this.activedPillSheet;
    if (activedPillSheet == null) {
      return 0;
    }

    final passedPillSheets = pillSheets.sublist(0, activedPillSheet.groupIndex);
    final passedPillCountForPillSheetTypes =
        summarizedPillSheetTypeTotalCountToPageIndex(
            pillSheetTypes:
                passedPillSheets.map((e) => e.pillSheetType).toList(),
            pageIndex: activedPillSheet.groupIndex);

    var sequentialLastTakenPillNumber =
        passedPillCountForPillSheetTypes + activedPillSheet.lastTakenPillNumber;

    final offsetPillNumber = this.offsetPillNumber;
    if (offsetPillNumber != null) {
      final beginPillNumberOffset = offsetPillNumber.beginPillNumber;
      if (beginPillNumberOffset != null) {
        sequentialLastTakenPillNumber += (beginPillNumberOffset - 1);
      }

      final endPillNumberOffset = offsetPillNumber.endPillNumber;
      if (endPillNumberOffset != null) {
        sequentialLastTakenPillNumber %= endPillNumberOffset;
        if (sequentialTodayPillNumber == 0) {
          sequentialLastTakenPillNumber = endPillNumberOffset;
        }
      }
    }

    return sequentialLastTakenPillNumber;
  }
}

@freezed
class OffsetPillNumber with _$OffsetPillNumber {
  @JsonSerializable(explicitToJson: true)
  const factory OffsetPillNumber({
    int? beginPillNumber,
    int? endPillNumber,
  }) = _OffsetPillNumber;

  factory OffsetPillNumber.fromJson(Map<String, dynamic> json) =>
      _$OffsetPillNumberFromJson(json);
}
