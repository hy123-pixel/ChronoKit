import SwiftUI

struct ContentView: View {
    @State private var now = Date()

    private let manager = TimeManager()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        let snapshot = manager.snapshot(from: now, weekdayStyle: .chinese)

        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    hero(snapshot: snapshot)
                    capabilityGrid
                    liveExamples(snapshot: snapshot)
                    codeSample(snapshot: snapshot)
                }
                .frame(maxWidth: 860)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .background(background.ignoresSafeArea())
            .navigationTitle("ChronoKit")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color(red: 0.05, green: 0.13, blue: 0.14), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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

    private var background: some View {
        ZStack {
            Color(red: 0.05, green: 0.13, blue: 0.14)

            LinearGradient(
                colors: [
                    Color(red: 0.68, green: 0.88, blue: 1.0).opacity(0.08),
                    Color.clear,
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            Circle()
                .fill(Color(red: 0.73, green: 0.85, blue: 1.0).opacity(0.06))
                .frame(width: 220, height: 220)
                .blur(radius: 100)
                .offset(x: 150, y: -300)
        }
    }

    private func hero(snapshot: TimeSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Open source time toolkit")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color(red: 0.71, green: 0.86, blue: 1.0))

            Text("Handle formatting, time zones, business rules, and date math in one clean Swift API.")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("ChronoKit ships as a reusable Swift Package with an ExampleApp so you can preview real outputs, ranges, ISO 8601 values, and world-clock conversions.")
                .font(.body)
                .foregroundStyle(Color.white.opacity(0.72))

            HStack(spacing: 10) {
                tag("Swift Package")
                tag("ExampleApp")
                tag("Foundation")
            }

            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(height: 1)

            HStack(spacing: 14) {
                heroMetric(
                    title: "Live preview",
                    value: snapshot.formatted,
                    detail: "\(snapshot.weekdayText) · Q\(snapshot.quarter)"
                )
                heroMetric(
                    title: "Week",
                    value: "W\(snapshot.weekOfYear)",
                    detail: snapshot.isWeekend ? "Weekend" : "Workday"
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(28)
        .background(heroBackground)
    }

    private var capabilityGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(eyebrow: "Capabilities", title: "Why teams use ChronoKit")

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                featureCard(
                    title: "Formatting",
                    text: "Convert `Date`, string, timestamp, and ISO 8601 formats with a small API surface."
                )
                featureCard(
                    title: "Calendar math",
                    text: "Get day, week, month, and year boundaries without sprinkling `Calendar` calls everywhere."
                )
                featureCard(
                    title: "Time zones",
                    text: "Render the same moment in Shanghai, London, New York, or your own configured zone."
                )
                featureCard(
                    title: "Business rules",
                    text: "Model weekends, holidays, and extra workdays in a reusable business calendar."
                )
            }
        }
        .padding(24)
        .background(sectionBackground)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func liveExamples(snapshot: TimeSnapshot) -> some View {
        let newYork = TimeZone(identifier: "America/New_York")!
        let london = TimeZone(identifier: "Europe/London")!
        let dayRange = manager.dayRange(for: snapshot.date)

        return VStack(alignment: .leading, spacing: 14) {
            sectionHeader(eyebrow: "Examples", title: "See the API in live output")

            exampleRow(
                title: "Today",
                leading: manager.string(from: snapshot.date, format: "yyyy-MM-dd HH:mm:ss"),
                trailing: snapshot.weekdayText
            )
            exampleRow(
                title: "ISO 8601",
                leading: manager.iso8601String(from: snapshot.date),
                trailing: "Standard"
            )
            exampleRow(
                title: "Day range",
                leading: "\(manager.string(from: dayRange.start, format: "HH:mm")) - \(manager.string(from: dayRange.end, format: "HH:mm"))",
                trailing: "Calendar"
            )
            exampleRow(
                title: "New York",
                leading: manager.timeZones.string(from: snapshot.date, format: "yyyy-MM-dd HH:mm:ss", in: newYork),
                trailing: "UTC\(manager.timeZones.offsetString(for: newYork))"
            )
            exampleRow(
                title: "London",
                leading: manager.timeZones.string(from: snapshot.date, format: "yyyy-MM-dd HH:mm:ss", in: london),
                trailing: "UTC\(manager.timeZones.offsetString(for: london))"
            )
        }
        .padding(24)
        .background(sectionBackground)
    }

    private func codeSample(snapshot: TimeSnapshot) -> some View {
        let sample = """
        let manager = TimeManager()
        let now = manager.currentString(format: "yyyy-MM-dd HH:mm:ss")
        let iso = manager.iso8601String(from: manager.currentDate())
        let workday = manager.business.isWorkday(Date())

        print(now)
        print(iso)
        print(workday)
        """

        return VStack(alignment: .leading, spacing: 14) {
            sectionHeader(eyebrow: "Developer Experience", title: "A focused Swift-first API")

            Text("The library stays close to Foundation while giving you cleaner entry points like `formatting`, `calendarTools`, `timeZones`, and `business`.")
                .font(.body)
                .foregroundStyle(Color.white.opacity(0.72))

            ScrollView(.horizontal, showsIndicators: false) {
                Text(sample)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundStyle(Color.white.opacity(0.92))
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.black.opacity(0.24))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
                            )
                    )
            }

            Text("Current preview output: \(snapshot.formatted)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .background(sectionBackground)
    }

    private func sectionHeader(eyebrow: String, title: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(eyebrow.uppercased())
                .font(.caption.weight(.semibold))
                .tracking(1.2)
                .foregroundStyle(Color(red: 0.68, green: 0.84, blue: 1.0))

            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
        }
    }

    private func tag(_ title: String) -> some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.white.opacity(0.07))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
    }

    private func heroMetric(title: String, value: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.white.opacity(0.58))

            Text(value)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(detail)
                .font(.footnote)
                .foregroundStyle(Color.white.opacity(0.68))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(tileBackground)
    }

    private func featureCard(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)

            Text(text)
                .font(.footnote)
                .foregroundStyle(Color.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, minHeight: 128, alignment: .leading)
        .padding(18)
        .background(featureBackground)
    }

    private func exampleRow(title: String, leading: String, trailing: String) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.white)

                    Text(leading)
                        .font(.footnote)
                        .foregroundStyle(Color.white.opacity(0.72))
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 12)

                Text(trailing)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color(red: 0.67, green: 0.84, blue: 1.0))
                    .multilineTextAlignment(.trailing)
            }
            .padding(.vertical, 10)

            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1)
        }
    }

    private var heroBackground: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.09, green: 0.21, blue: 0.23),
                        Color(red: 0.06, green: 0.14, blue: 0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
    }

    private var sectionBackground: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(Color(red: 0.08, green: 0.17, blue: 0.18).opacity(0.96))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
    }

    private var tileBackground: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(Color.white.opacity(0.04))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
    }

    private var featureBackground: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(Color(red: 0.10, green: 0.20, blue: 0.21))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
    }
}

#Preview {
    ContentView()
}
