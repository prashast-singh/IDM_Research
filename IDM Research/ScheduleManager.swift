//  ScheduleManager.swift
//  IDM Research

//  ScheduleManager.swift
//  IDM Research

//  ScheduleManager.swift
//  IDM Research

//  ScheduleManager.swift
//  IDM Research

import Foundation
import UserNotifications
import Combine
import SwiftUI

/// Manages task frequencies, last-run dates, computes next-due dates & remaining times, and schedules local alerts in the user's local timezone.
class ScheduleManager: ObservableObject {
    /// Different tasks that can be scheduled
    enum Task: String, CaseIterable {
        case questionnaire, gait, sixMWT, twoMWT, leftKneeROM, rightKneeROM

        var displayName: String {
            switch self {
            case .questionnaire:  return "Questionnaire"
            case .gait:           return "Gait & Balance"
            case .sixMWT:         return "6MWT"
            case .twoMWT:         return "2MWT"
            case .leftKneeROM:    return "Left Knee ROM"
            case .rightKneeROM:   return "Right Knee ROM"
            }
        }
    }

    enum Frequency: String, CaseIterable, Identifiable {
        case none       = "None"
        case hourly     = "Hourly"
        case daily      = "Daily"
        case weekly     = "Weekly"
        case biWeekly   = "Every 2 Weeks"
        case triWeekly  = "Every 3 Weeks"
        case monthly    = "Monthly"

        var id: String { rawValue }

        /// The calendar date component to add for the next run.
        var dateComponents: DateComponents? {
            switch self {
            case .hourly:    return DateComponents(hour: 1)
            case .daily:     return DateComponents(day: 1)
            case .weekly:    return DateComponents(weekOfYear: 1)
            case .biWeekly:  return DateComponents(weekOfYear: 2)
            case .triWeekly: return DateComponents(weekOfYear: 3)
            case .monthly:   return DateComponents(month: 1)
            default:         return nil
            }
        }
    }

    // MARK: - Stored Settings (AppStorage keys)
    @AppStorage("freq_questionnaire")    var questionnaireRaw   = Frequency.none.rawValue { didSet { scheduleChanged() } }
    @AppStorage("freq_gait")             var gaitRaw            = Frequency.none.rawValue { didSet { scheduleChanged() } }
    @AppStorage("freq_sixMWT")           var sixRaw             = Frequency.none.rawValue { didSet { scheduleChanged() } }
    @AppStorage("freq_twoMWT")           var twoRaw             = Frequency.none.rawValue { didSet { scheduleChanged() } }
    @AppStorage("freq_leftKneeROM")      var leftKneeROMRaw     = Frequency.none.rawValue { didSet { scheduleChanged() } }
    @AppStorage("freq_rightKneeROM")     var rightKneeROMRaw    = Frequency.none.rawValue { didSet { scheduleChanged() } }

    @AppStorage("last_questionnaire")    private var lastQuestionnaire: Date?
    @AppStorage("last_gait")             private var lastGait: Date?
    @AppStorage("last_sixMWT")           private var lastSixMWT: Date?
    @AppStorage("last_twoMWT")           private var lastTwoMWT: Date?
    @AppStorage("last_leftKneeROM")      private var lastLeftKneeROM: Date?
    @AppStorage("last_rightKneeROM")     private var lastRightKneeROM: Date?

    // MARK: - Published Outputs
    @Published private(set) var nextDue   = [Task: Date]()
    @Published private(set) var remaining = [Task: TimeInterval]()

    private var timerCancellable: AnyCancellable?

    init() {
        updateSchedules()
        scheduleNotifications()

        // Refresh remaining times every minute
        timerCancellable = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.updateSchedules() }
    }

    private func scheduleChanged() {
        updateSchedules()
        scheduleNotifications()
    }

    private func updateSchedules() {
        let now = Date()
        nextDue.removeAll()
        remaining.removeAll()

        for task in Task.allCases {
            guard let freq = getFrequency(for: task) else { continue }

            let due: Date?
            if freq == .daily {
                let startOfToday = Calendar.current.startOfDay(for: now)
                due = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)
            } else if let comps = freq.dateComponents {
                let lastDate = getLastDate(for: task) ?? now
                due = Calendar.current.date(byAdding: comps, to: lastDate)
            } else {
                due = nil
            }

            if let nextDate = due, nextDate > now {
                nextDue[task]   = nextDate
                remaining[task] = nextDate.timeIntervalSince(now)
            }
        }
    }

    private func getFrequency(for task: Task) -> Frequency? {
        let raw: String
        switch task {
        case .questionnaire: raw = questionnaireRaw
        case .gait:          raw = gaitRaw
        case .sixMWT:        raw = sixRaw
        case .twoMWT:        raw = twoRaw
        case .leftKneeROM:   raw = leftKneeROMRaw
        case .rightKneeROM:  raw = rightKneeROMRaw
        }
        return Frequency(rawValue: raw)
    }

    private func getLastDate(for task: Task) -> Date? {
        switch task {
        case .questionnaire:  return lastQuestionnaire
        case .gait:           return lastGait
        case .sixMWT:         return lastSixMWT
        case .twoMWT:         return lastTwoMWT
        case .leftKneeROM:    return lastLeftKneeROM
        case .rightKneeROM:   return lastRightKneeROM
        }
    }

    /// Call this when a task is completed to reset its timer
    func recordCompletion(of task: Task) {
        let now = Date()
        switch task {
        case .questionnaire:  lastQuestionnaire  = now
        case .gait:           lastGait           = now
        case .sixMWT:         lastSixMWT         = now
        case .twoMWT:         lastTwoMWT         = now
        case .leftKneeROM:    lastLeftKneeROM    = now
        case .rightKneeROM:   lastRightKneeROM   = now
        }
        scheduleChanged()
    }

    // MARK: - Notifications
    func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        for (task, due) in nextDue {
            let interval = due.timeIntervalSinceNow
            guard interval > 0 else { continue }

            let content = UNMutableNotificationContent()
            content.title = "\(task.displayName) Due Soon"
            content.body  = "Your next \(task.displayName) is coming up."
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            let request = UNNotificationRequest(identifier: task.rawValue, content: content, trigger: trigger)
            center.add(request)
        }
    }
}
