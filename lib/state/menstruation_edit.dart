import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/menstruation.dart';

part 'menstruation_edit.freezed.dart';

@freezed
abstract class MenstruationEditState implements _$MenstruationEditState {
  MenstruationEditState._();
  factory MenstruationEditState({
    @Default(false) bool isAlreadyAdjsutScrollOffset,
    required Menstruation? menstruation,
    required List<DateTime> displayedDates,
    String? invalidMessage,
    Object? exception,
  }) = _MenstruationEditState;

  List<DateTime> dates() => displayedDates;
}
