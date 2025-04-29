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
    @State private var selectedRange: TimeRange = .week
    @StateObject private var viewModel = HealthDataViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Time Range Picker
                Picker("Time Range", selection: $selectedRange) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Chart list
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
            }
            .navigationTitle("Health Metrics")
            .onAppear {
                viewModel.loadData(for: selectedRange)
            }
            .onChange(of: selectedRange) { newValue in
                viewModel.loadData(for: newValue)
            }
        }
    }

    private func chartForMetric(_ metric: HealthMetric) -> some View {
        Chart {
            ForEach(metric.dataPoints) { point in
                if selectedRange == .day {
                    BarMark(
                        x: .value("Time", point.date),
                        y: .value("Steps", point.value)
                    )
                } else {
                    LineMark(
                        x: .value("Time", point.date),
                        y: .value("Value", point.value)
                    )
                    .interpolationMethod(.monotone)
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(shortLabel(for: date))
                    }
                }
            }
        }
        .frame(height: 200)
    }



    private func avgLabel(for metric: HealthMetric) -> some View {
        let label: String
        if metric.identifier == .stepCount && selectedRange == .day {
            let total = metric.dataPoints.reduce(0) { $0 + $1.value }
            label = "Total: \(Int(total)) \(metric.unit)"
        } else {
            label = "Avg: \(String(format: "%.2f", metric.average)) \(metric.unit)"
        }

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
}



