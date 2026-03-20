import SwiftUI

struct ContentView: View {
    @State private var now = Date()

    private let manager = TimeManager()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        let snapshot = manager.snapshot(from: now, weekdayStyle: .chinese)

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header(snapshot: snapshot)
                    components(snapshot: snapshot)
                    boundaries(snapshot: snapshot)
                    standards(snapshot: snapshot)
                    conversions(snapshot: snapshot)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("ChronoKit")
            .toolbar {
                Button("Refresh") {
                    now = Date()
                }
            }
        }
        .onReceive(timer) { value in
            now = value
        }
    }

    private func header(snapshot: TimeSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("当前时间")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(snapshot.formatted)
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text(snapshot.weekdayText)
                .font(.title3)
                .foregroundStyle(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func components(snapshot: TimeSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("日期组件")
                .font(.headline)

            infoRow(title: "年份", value: "\(snapshot.year)")
            infoRow(title: "月份", value: "\(snapshot.month)")
            infoRow(title: "日期", value: "\(snapshot.day)")
            infoRow(title: "小时", value: "\(snapshot.hour)")
            infoRow(title: "分钟", value: "\(snapshot.minute)")
            infoRow(title: "秒", value: "\(snapshot.second)")
        }
        .padding(20)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func conversions(snapshot: TimeSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("时间戳转换")
                .font(.headline)

            infoRow(title: "秒级时间戳", value: "\(snapshot.timestampSeconds)")
            infoRow(title: "毫秒时间戳", value: "\(snapshot.timestampMilliseconds)")
            infoRow(
                title: "时间戳转字符串",
                value: manager.string(
                    fromTimestamp: snapshot.timestampSeconds,
                    format: "yyyy/MM/dd HH:mm:ss",
                    isMilliseconds: false
                )
            )
        }
        .padding(20)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func standards(snapshot: TimeSnapshot) -> some View {
        let newYork = TimeZone(identifier: "America/New_York")!

        return VStack(alignment: .leading, spacing: 12) {
            Text("标准与时区")
                .font(.headline)

            infoRow(title: "ISO8601", value: manager.iso8601String(from: snapshot.date))
            infoRow(
                title: "纽约时间",
                value: manager.timeZones.string(from: snapshot.date, format: "yyyy-MM-dd HH:mm:ss", in: newYork)
            )
            infoRow(title: "纽约偏移", value: manager.timeZones.offsetString(for: newYork))
            infoRow(title: "模块入口", value: "formatting / calendarTools / comparison / timeZones / business")
        }
        .padding(20)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func boundaries(snapshot: TimeSnapshot) -> some View {
        let dayRange = manager.dayRange(for: snapshot.date)

        return VStack(alignment: .leading, spacing: 12) {
            Text("业务判断")
                .font(.headline)

            infoRow(title: "季度", value: "\(snapshot.quarter)")
            infoRow(title: "周数", value: "\(snapshot.weekOfYear)")
            infoRow(title: "年内第几天", value: "\(snapshot.dayOfYear)")
            infoRow(title: "是否周末", value: snapshot.isWeekend ? "是" : "否")
            infoRow(title: "相对描述", value: manager.relativeDescription(for: snapshot.date))
            infoRow(title: "当日开始", value: manager.string(from: dayRange.start, format: "yyyy-MM-dd HH:mm:ss"))
            infoRow(title: "当日结束", value: manager.string(from: dayRange.end, format: "yyyy-MM-dd HH:mm:ss"))
        }
        .padding(20)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    ContentView()
}
