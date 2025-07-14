//
//  ResultView.swift
//  IDM Research
//
//  Created by Prashast Singh on 23.04.25.
//
//  ResultsView.swift
//  IDM Research

import SwiftUI
import HealthKit
import Charts
import CoreData

enum TimeRange: String, CaseIterable {
    case day = "D"
    case week = "W"
    case month = "M"
    case sixMonths = "6M"
    case year = "Y"
}

struct DataPoint: Identifiable {
    var id = UUID()
    var date: Date
    var value: Double
}

struct HealthMetric: Identifiable {
    var id: String { identifier.rawValue }
    var name: String
    var unit: String
    var identifier: HKQuantityTypeIdentifier
    var dataPoints: [DataPoint] = []
    var average: Double = 0.0
}

class HealthDataViewModel: ObservableObject {
    @Published var healthMetrics: [HealthMetric] = []
    private let healthStore = HKHealthStore()

    private let metrics: [(HKQuantityTypeIdentifier, String, String)] = [
        (.stepCount, "Step Count", "steps"),
        (.walkingSpeed, "Walking Speed", "m/s"),
        (.walkingStepLength, "Step Length", "m"),
        (.walkingDoubleSupportPercentage, "Double Support", "%"),
        (.walkingAsymmetryPercentage, "Asymmetry", "%")
    ]

    func loadData(for timeRange: TimeRange) {
        healthMetrics = [] // Reset

        for (identifier, name, unit) in metrics {
            let type = HKQuantityType.quantityType(forIdentifier: identifier)!
            fetchStatistics(for: type, identifier: identifier, name: name, unit: unit, timeRange: timeRange)
        }
    }

    private func fetchStatistics(for type: HKQuantityType, identifier: HKQuantityTypeIdentifier, name: String, unit: String, timeRange: TimeRange) {
        let calendar = Calendar.current
        var interval = DateComponents()

        if timeRange == .day {
            if identifier == .stepCount {
                interval.hour = 1  // One data point for the whole day (total steps)
            } else {
                interval.hour = 1 // Hourly data for rest (for averaging)
            }
        } else {
            interval.day = 1
        }


        let endDate = Date()
        let startDate: Date
        switch timeRange {
        case .day:
            startDate = calendar.startOfDay(for: endDate) // Set start to midnight of current day
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: endDate)!
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: endDate)!
        case .sixMonths:
            startDate = calendar.date(byAdding: .month, value: -6, to: endDate)!
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: endDate)!
        }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)

        // Adjust options based on the type
        var options: HKStatisticsOptions
        if type == HKQuantityType.quantityType(forIdentifier: .stepCount) {
            options = [.cumulativeSum] // For step count, use cumulative sum
        } else {
            options = [.discreteAverage] // For walking speed (and other discrete types), use discrete average
        }

        let query = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: options,
            anchorDate: calendar.startOfDay(for: startDate),
            intervalComponents: interval
        )

        query.initialResultsHandler = { _, results, error in
            guard let statsCollection = results else { return }

            var dataPoints: [DataPoint] = []
            var total: Double = 0
            var count: Int = 0

            statsCollection.enumerateStatistics(from: startDate, to: endDate) { stat, _ in
                var value: Double = 0
                var valid = false
                if identifier == .stepCount {
                    if let quantity = stat.sumQuantity() {
                        value = quantity.doubleValue(for: HKUnit.count())
                        valid = true
                    }
                } else {
                    if let quantity = stat.averageQuantity() {
                        value = quantity.doubleValue(for: HKUnit(from: unit))
                        
                        if identifier == .walkingAsymmetryPercentage || identifier == .walkingDoubleSupportPercentage {
                            value *= 100
                        }
                        valid = true
                    }
                }



                dataPoints.append(DataPoint(date: stat.startDate, value: value))

                if valid {
                        total += value
                        count += 1
                    }

            }

            DispatchQueue.main.async {
                let average = count > 0 ? total / Double(count) : 0.0

                let metric = HealthMetric(
                    name: name,
                    unit: unit,
                    identifier: identifier,
                    dataPoints: dataPoints,
                    average: average
                )
                self.healthMetrics.append(metric)
            }
        }

        healthStore.execute(query)
    }

}


struct ResultsView: View {
    enum ResultsTab { case health, active }
    @State private var selectedTab: ResultsTab = .health
    @State private var selectedRange: TimeRange = .week
    @StateObject private var viewModel = HealthDataViewModel()
    @FetchRequest(
        entity: WalkResult.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WalkResult.date, ascending: false)]
    ) var walkResults: FetchedResults<WalkResult>
    @FetchRequest(
        entity: KneeROMResult.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \KneeROMResult.date, ascending: false)]
    ) var kneeResults: FetchedResults<KneeROMResult>

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: { selectedTab = .health }) {
                        Text("Health Metrics")
                            .fontWeight(selectedTab == .health ? .bold : .regular)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedTab == .health ? Color.blue.opacity(0.1) : Color.clear)
                            .foregroundColor(selectedTab == .health ? .blue : .primary)
                    }
                    Button(action: { selectedTab = .active }) {
                        Text("Active Task")
                            .fontWeight(selectedTab == .active ? .bold : .regular)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedTab == .active ? Color.blue.opacity(0.1) : Color.clear)
                            .foregroundColor(selectedTab == .active ? .blue : .primary)
                    }
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.top)

                Spacer().frame(height: 8) // Move the gap here, after the tab selector

                if selectedTab == .health {
                    // Health Metrics Tab
                    Picker("Time Range", selection: $selectedRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.healthMetrics) { metric in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("\(metric.name) (\(metric.unit))")
                                        .font(.headline)

                                    if metric.dataPoints.isEmpty {
                                        Text("No data available")
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    } else {
                                        chartForMetric(metric)
                                        avgLabel(for: metric)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGroupedBackground))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    // Active Task Tab
                    Picker("Time Range", selection: $selectedRange) {
                        ForEach([TimeRange.week, .month, .sixMonths, .year], id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(groupedWalkResults, id: \ .taskType) { group in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(group.heading)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .padding(.bottom, 4)
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(group.results) { walk in
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Steps: \(walk.steps)")
                                                        .font(.headline)
                                                    Text(formattedDate(walk.date))
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                }
                                                .padding()
                                                .background(Color(.systemGroupedBackground))
                                                .cornerRadius(12)
                                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                            }
                            ForEach(groupedKneeResults, id: \ .taskType) { group in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(group.heading)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .padding(.bottom, 4)
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(group.results) { knee in
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Angle: \(String(format: "%.1f", knee.angle))°")
                                                        .font(.headline)
                                                    Text(formattedDate(knee.date))
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                }
                                                .padding()
                                                .background(Color(.systemGroupedBackground))
                                                .cornerRadius(12)
                                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .navigationTitle(selectedTab == .health ? "Health Metrics" : "Active Task Results")
            .onAppear {
                viewModel.loadData(for: selectedRange)
            }
            .onChange(of: selectedRange) { newValue in
                viewModel.loadData(for: newValue)
            }
        }
    }

    // Filtered results for Active Task tab
    private var filteredWalkResults: [WalkResult] {
        filterResults(walkResults.map { $0 })
    }
    private var filteredKneeResults: [KneeROMResult] {
        filterResults(kneeResults.map { $0 })
    }
    private func filterResults<T: NSManagedObject>(_ results: [T]) -> [T] {
        let now = Date()
        let calendar = Calendar.current
        let startDate: Date
        switch selectedRange {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .sixMonths:
            startDate = calendar.date(byAdding: .month, value: -6, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        default:
            startDate = calendar.startOfDay(for: now)
        }
        return results.filter {
            if let date = $0.value(forKey: "date") as? Date {
                return date >= startDate && date <= now
            }
            return false
        }
    }

    private func chartForMetric(_ metric: HealthMetric) -> some View {
        let grouped = groupedDataPoints(for: metric).filter { !$0.values.isEmpty }
        if grouped.isEmpty {
            return AnyView(
                Text("No data available")
                    .frame(height: 200)
                    .background(Color(.systemGroupedBackground))
            )
        }
        // Flatten all values for the average
        let allValues = grouped.flatMap { $0.values }
        let avg = allValues.isEmpty ? 0 : allValues.reduce(0, +) / Double(allValues.count)
        return AnyView(
            Chart {
                ForEach(grouped, id: \.label) { group in
                    BarMark(
                        x: .value("X", group.label),
                        y: .value("Value", group.values.reduce(0, +) / Double(group.values.count))
                    )
                    .foregroundStyle(Color.accentColor)
                }
                RuleMark(
                    y: .value("Avg", avg)
                )
                .foregroundStyle(Color.orange)
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [4]))
                .annotation(position: .top, alignment: .trailing) {
                    Text("Avg: \(String(format: "%.2f", avg)) \(metric.unit)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            .frame(height: 200)
        )
    }

    // Helper to group data points by selected range
    private func groupedDataPoints(for metric: HealthMetric) -> [(label: String, values: [Double])] {
        let calendar = Calendar.current
        var groups: [String: [Double]] = [:]
        switch selectedRange {
        case .day:
            // Group by hour
            for point in metric.dataPoints {
                let hour = calendar.component(.hour, from: point.date)
                let label = String(format: "%02d:00", hour)
                groups[label, default: []].append(point.value)
            }
        case .week, .month:
            // Group by day
            for point in metric.dataPoints {
                let day = calendar.component(.day, from: point.date)
                let label = String(format: "%02d", day)
                groups[label, default: []].append(point.value)
            }
        case .sixMonths:
            // Group by 4-week period
            for point in metric.dataPoints {
                let weekOfYear = calendar.component(.weekOfYear, from: point.date)
                let period = (weekOfYear - 1) / 4 + 1
                let label = "W\(period * 4)"
                groups[label, default: []].append(point.value)
            }
        case .year:
            // Group by month
            for point in metric.dataPoints {
                let month = calendar.component(.month, from: point.date)
                let label = calendar.shortMonthSymbols[month - 1]
                groups[label, default: []].append(point.value)
            }
        }
        // Aggregate (average) for each group
        return groups
            .sorted { $0.key < $1.key }
            .map { (label: $0.key, values: $0.value) }
    }


    private func avgLabel(for metric: HealthMetric) -> some View {
        let allValues = metric.dataPoints.map { $0.value }
        let avg = allValues.isEmpty ? 0 : allValues.reduce(0, +) / Double(allValues.count)
        let label = "Avg: \(String(format: "%.2f", avg)) \(metric.unit)"
        return Text(label)
            .font(.caption)
            .foregroundColor(.secondary)
    }


    private func shortLabel(for date: Date) -> String {
        if selectedRange == .day {
            return shortHourString(from: date)
        } else {
            return shortDateString(from: date)
        }
    }

    // Helper for formatting dates
    private func shortDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    // Helper for formatting hours
    private func shortHourString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// --- Apple Health-Style Card and Chart Components ---

// Remove HealthMetricAppleCard and HealthMetricBarChartViewApple definitions
// Restore the Health Metrics tab to show all metrics in the same style, with heading, bar chart, and average label
// Update chartForMetric and avgLabel to ignore zero/null values in calculations

private struct WalkResultGroup {
    let taskType: String
    let heading: String
    let results: [WalkResult]
}
private struct KneeResultGroup {
    let taskType: String
    let heading: String
    let results: [KneeROMResult]
}

private extension ResultsView {
    var groupedWalkResults: [WalkResultGroup] {
        let groups = Dictionary(grouping: filteredWalkResults, by: { $0.taskType ?? "Unknown Walk" })
        return groups.map { (key, value) in
            WalkResultGroup(taskType: key, heading: walkHeading(for: key), results: value)
        }.sorted { $0.heading < $1.heading }
    }
    var groupedKneeResults: [KneeResultGroup] {
        let groups = Dictionary(grouping: filteredKneeResults, by: { $0.taskType ?? "Unknown ROM" })
        return groups.map { (key, value) in
            KneeResultGroup(taskType: key, heading: kneeHeading(for: key), results: value)
        }.sorted { $0.heading < $1.heading }
    }
    func walkHeading(for key: String) -> String {
        switch key {
        case "6MWT": return "6-Minute Walk Test"
        case "TwoMinuteWalkTest": return "2-Minute Walk Test"
        case "shortWalk": return "Short Walk"
        default: return key
        }
    }
    func kneeHeading(for key: String) -> String {
        switch key {
        case "rightKneeROM": return "Right Knee ROM"
        case "lefttKneeROM": return "Left Knee ROM"
        default: return key
        }
    }
}



