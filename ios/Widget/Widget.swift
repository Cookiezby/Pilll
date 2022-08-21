import WidgetKit
import SwiftUI
import Intents

fileprivate var calendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    #if DEBUG
    calendar.locale = .init(identifier: "ja_JP")
    #endif
    return calendar
}

fileprivate var dateFormater: DateFormatter {
    let dateFormater = DateFormatter()
    dateFormater.locale = .init(identifier: "ja_JP")
    return dateFormater
}

struct Provider: TimelineProvider {
    typealias Entry = PillSheetEntry

    func placeholder(in context: Context) -> Entry {
        .init(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let intervalMinute = 15
        let oneDayLoopCount = 24 * (4 * intervalMinute)
        let entries: [PillSheetEntry] = .init(repeating: .init(date: .now.addingTimeInterval(TimeInterval(intervalMinute * 60))), count: oneDayLoopCount)
        let nextTimelineSchedule = Calendar.current.date(byAdding: .minute, value: intervalMinute, to: .now)!
        let timeline = Timeline(entries: entries, policy: .after(nextTimelineSchedule))
        completion(timeline)
    }
}

struct PillSheetEntry: TimelineEntry {
    // Timeline Entry required property
    let date: Date

    // PillSheet property
    let todayPillNumber: Int?
    let lastTakenPillNumber: Int?
    let pilllNumberDisplayMode: String?

    init(date: Date) {
        self.date = date

        func contains(_ key: String) -> Bool {
            UserDefaults(suiteName: Const.appGroupKey)?.dictionaryRepresentation().keys.contains(key) == true
        }

        todayPillNumber = contains(Const.todayPillNumber) ? UserDefaults(suiteName: Const.appGroupKey)?.integer(forKey: Const.todayPillNumber) : nil
        lastTakenPillNumber = contains(Const.lastTakenPillNumber) ? UserDefaults(suiteName: Const.appGroupKey)?.integer(forKey: Const.lastTakenPillNumber) : nil
        pilllNumberDisplayMode = contains(Const.pilllNumberDisplayMode) ? UserDefaults(suiteName: Const.appGroupKey)?.string(forKey: Const.pilllNumberDisplayMode) : nil
    }
}

struct WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(spacing: 0) {
                    Text(weekday)
                        .foregroundColor(.mainText)
                        .font(.system(size: 12))
                        .fontWeight(.medium)

                    Text("\(day)")
                        .foregroundColor(.black)
                        .font(.system(size: 36))
                        .fontWeight(.regular)
                }

                Spacer()

                Image("pilll-widget-icon")
                    .frame(width: 11, height: 16)
            }

            Spacer()

            if let lastTakenPillNumber = entry.lastTakenPillNumber, let todayPillNumber = entry.todayPillNumber {
                let alreadyTaken = lastTakenPillNumber == todayPillNumber
                HStack {
                    HStack(spacing: 6) {
                        Divider()
                            .frame(width: 4)
                            .overlay(alreadyTaken ? Color.primary : Color.orange)
                            .cornerRadius(2)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.pilllNumberDisplayMode == "date" ? "\(todayPillNumber)日目" : "\(todayPillNumber)番")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)

                            Text(alreadyTaken ? "服用済み" : "未服用")
                                .foregroundColor(.mainText)
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                        }
                    }

                    Spacer()

                    Image(alreadyTaken ? "check-icon-on.svg" : "check-icon-off.svg")
                        .frame(width: 32, height: 32)
                        .shadow(color: Color(red: 78 / 255, green: 98 / 255, blue: 135 / 255, opacity: 0.4), radius: 5, x: 0, y: 2)
                }
                .frame(maxHeight: 40)
            } else {
                HStack {
                    HStack(spacing: 6) {
                        Divider()
                            .frame(width: 4)
                            .overlay(Color(red: 190 / 255, green: 192 / 255, blue: 194 / 255))
                            .cornerRadius(2)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("- 番")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)

                            Text("シートがありません")
                                .foregroundColor(.orange)
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                                .background(Color(red: 230 / 255, green: 94 / 255, blue: 90 / 255, opacity: 0.1))
                        }
                    }

                    Spacer()
                }
                .frame(maxHeight: 40)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(Color.white)
    }

    private var weekday: String {
        dateFormater.weekdaySymbols[calendar.component(.weekday, from: entry.date) - 1]
    }

    private var day: Int {
        calendar.component(.day, from: entry.date)
    }

}

extension Color {
    static let primary: Color = .init(red: 78 / 255, green: 98 / 255, blue: 135 / 255)
    static let orange: Color = .init(red: 229 / 255, green: 106 / 255, blue: 69 / 255)
    static let mainText: Color = .init(red: 41 / 255, green: 48 / 255, blue: 77 / 255, opacity: 0.87)
}

@main
struct Entrypoint: Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .description("This is an Pilll widget")
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: .init(date: .now))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

