import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/features/historical_pill_sheet_group/component/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:flutter/material.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/setting.dart';

class HistoricalPillSheetGroupPage extends HookConsumerWidget {
  const HistoricalPillSheetGroupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueGroup.group2(
      ref.watch(beforePillSheetGroupProvider),
      ref.watch(settingProvider),
    ).when(
      data: (data) {
        return _Page(
          pillSheetGroup: data.t1,
          activePillSheet: data.t1?.activePillSheet,
          setting: data.t2,
        );
      },
      error: (error, stackTrace) => UniversalErrorPage(
        error: error,
        reload: () => ref.refresh(refreshAppProvider),
        child: null,
      ),
      loading: () => const Indicator(),
    );
  }
}

class _Page extends HookConsumerWidget {
  final PillSheetGroup? pillSheetGroup;
  final PillSheet? activePillSheet;
  final Setting setting;

  const _Page({
    Key? key,
    required this.pillSheetGroup,
    required this.activePillSheet,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillSheetGroup = this.pillSheetGroup;
    final activePillSheet = this.activePillSheet;
    if (pillSheetGroup == null || activePillSheet == null) {
      return Scaffold(
        backgroundColor: PilllColors.background,
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: PilllColors.white,
          title: const Text("以前のピルシートグループ"),
          foregroundColor: TextColor.main,
        ),
        body: const Center(child: Text("以前のピルシートグループがまだ存在しません")),
      );
    }

    final pageController = usePageController(
        initialPage: activePillSheet.groupIndex, viewportFraction: (PillSheetViewLayout.width + 20) / MediaQuery.of(context).size.width);

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: PilllColors.white,
        title: const Text("以前のピルシートグループ"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: PillSheetViewLayout.calcHeight(
              PillSheetViewLayout.mostLargePillSheetType(pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList()).numberOfLineInPillSheet,
              false,
            ),
            child: PageView(
              clipBehavior: Clip.none,
              controller: pageController,
              scrollDirection: Axis.horizontal,
              children: pillSheetGroup.pillSheets
                  .map((pillSheet) {
                    return [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: HistoricalPillsheetGroupPagePillSheet(
                          pillSheetGroup: pillSheetGroup,
                          pillSheet: pillSheet,
                          setting: setting,
                        ),
                      ),
                    ];
                  })
                  .expand((element) => element)
                  .toList(),
            ),
          ),
          if (pillSheetGroup.pillSheets.length > 1) ...[
            const SizedBox(height: 16),
            DotsIndicator(
              controller: pageController,
              itemCount: pillSheetGroup.pillSheets.length,
              onDotTapped: (page) {
                pageController.animateToPage(
                  page,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            )
          ]
        ],
      ),
    );
  }
}

extension HistoricalPillSheetGroupPageRoute on HistoricalPillSheetGroupPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "HistoricalPillSheetGroupPage"),
      builder: (_) => const HistoricalPillSheetGroupPage(),
    );
  }
}
