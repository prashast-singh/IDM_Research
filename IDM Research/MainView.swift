//  MainView.swift
//  IDM Research

import SwiftUI
import ResearchKitUI
import ResearchKitActiveTask
import UIKit
import ResearchKit_Private
import AVFoundation
import CoreLocation

final class BackgroundKeeper: NSObject, CLLocationManagerDelegate {
    static let shared = BackgroundKeeper()
    private let locationManager = CLLocationManager()
    private var audioPlayer: AVAudioPlayer?

    private override init() {
        super.init()
        setupAudioSession()
        setupLocationUpdates()
    }

    // MARK: – Audio
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
            if let url = Bundle.main.url(forResource: "1-minute-of-silence", withExtension: "mp3") {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1
            }
        } catch {
            print("Audio setup failed: \(error)")
        }
    }

    func startAudioLoop() { audioPlayer?.play() }
    func stopAudioLoop()  { audioPlayer?.stop()  }

    // MARK: – Location
    private func setupLocationUpdates() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    func startLocation() { locationManager.startUpdatingLocation() }
    func stopLocation()  { locationManager.stopUpdatingLocation() }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
}

// MARK: - Side Menu
struct SideMenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button("Profile") {}
            Button("AI Assistant") {}
            Button("Contact Us") {}
            Spacer()
        }
        .padding(.top, 100)
        .padding(.horizontal, 20)
        .frame(maxWidth: 250, alignment: .leading)
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainView: View {
    @EnvironmentObject var scheduleManager: ScheduleManager
    @State private var showConsent       = false
    @State private var showQuestionnaire = false
    @State private var showShortWalkTask = false
    @State private var show6MWTT         = false
    @State private var show2MWTT         = false
    @State private var showLeftKneeROM   = false
    @State private var showRightKneeROM  = false
    @State private var showPerform       = false
    @State private var showMenu          = false

    var body: some View {
        contentView
            .fullScreenCover(isPresented: $showConsent)       { ConsentView(isPresented: $showConsent) }
            .fullScreenCover(isPresented: $showQuestionnaire) { questionnaireCover }
            .fullScreenCover(isPresented: $showShortWalkTask) { shortWalkCover }
            .fullScreenCover(isPresented: $show6MWTT)         { sixMWTCover }
            .fullScreenCover(isPresented: $show2MWTT)         { twoMWTCover }
            .fullScreenCover(isPresented: $showLeftKneeROM)   { leftKneeCover }
            .fullScreenCover(isPresented: $showRightKneeROM)  { rightKneeCover }
    }

    // MARK: - Extracted Root Content
    private var contentView: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                mainContent
                if showMenu { sideMenuOverlay }
            }
            .navigationBarHidden(true)
        }
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            header
            Spacer()
            ScrollView { notificationList }
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    private var header: some View {
    VStack(spacing: 0) {
        HStack {
            Text("IDM Research")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Button(action: { withAnimation { showMenu.toggle() } }) {
                Image(systemName: "line.horizontal.3")
                    .font(.title)
                    .padding()
            }
        }
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground))
        Divider()
    }
}

    private var notificationList: some View {
        VStack(spacing: 16) {
            ForEach(scheduleManager.remaining.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { task, secs in
                notificationCard(task: task, secs: secs)
            }
            Spacer(minLength: 20)
            performGroup
        }
    }

    private func notificationCard(task: ScheduleManager.Task, secs: TimeInterval) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "bell.circle.fill")
                .font(.title)
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 4) {
                Text(task.displayName)
                    .font(.headline)
                Text(formatInterval(secs) + " remaining")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }

    private var performGroup: some View {
        DisclosureGroup("Perform Task", isExpanded: $showPerform) {
            VStack(spacing: 16) {
                Button("View Consent") { showConsent = true }
                    .buttonStyle(FilledButtonStyle(color: .blue))
                if scheduleManager.questionnaireRaw != ScheduleManager.Frequency.none.rawValue {
                    Button("Questionnaire") { showQuestionnaire = true }
                        .buttonStyle(FilledButtonStyle(color: .purple))
                }
                NavigationLink("Tests", destination: TestsView(
                    showShortWalkTask: $showShortWalkTask,
                    show6MWTT:         $show6MWTT,
                    show2MWTT:         $show2MWTT,
                    showLeftKneeROM:   $showLeftKneeROM,
                    showRightKneeROM:  $showRightKneeROM
                ))
                .buttonStyle(FilledButtonStyle(color: .green))
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }

    private var sideMenuOverlay: some View {
        Color.black.opacity(0.3)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture { withAnimation { showMenu = false } }
            .overlay(SideMenuView().transition(.move(edge: .leading)))
    }

    // MARK: - Full Screen Covers
    private var questionnaireCover: some View {
        TaskView(task: activeTask) { reason, result in
            if reason == .completed, let res = result {
                processResult(res)
                scheduleManager.recordCompletion(of: .questionnaire)
            }
            showQuestionnaire = false
        }
    }
    private var shortWalkCover: some View {
        TaskView(task: shortWalkTask) { reason, result in
            if reason == .completed, let res = result {
                processResult(res)
                scheduleManager.recordCompletion(of: .gait)
            }
            showShortWalkTask = false
            BackgroundKeeper.shared.stopAudioLoop()
        }
    }
    private var sixMWTCover: some View {
        TaskView(task: sixMinWalkTask) { reason, result in
            if reason == .completed, let res = result {
                processResult(res)
                scheduleManager.recordCompletion(of: .sixMWT)
            }
            show6MWTT = false
            BackgroundKeeper.shared.stopAudioLoop()
        }
    }
    private var twoMWTCover: some View {
        TaskView(task: twoMinuteWalkTest) { reason, result in
            if reason == .completed, let res = result {
                processResult(res)
                scheduleManager.recordCompletion(of: .twoMWT)
            }
            show2MWTT = false
            BackgroundKeeper.shared.stopAudioLoop()
        }
    }
    private var leftKneeCover: some View {
        TaskView(task: leftKneeRangeOfMotion) { reason, result in
            if reason == .completed, let res = result {
                processResult(res)
                scheduleManager.recordCompletion(of: .leftKneeROM)
            }
            showLeftKneeROM = false
            BackgroundKeeper.shared.stopAudioLoop()
        }
    }
    private var rightKneeCover: some View {
        TaskView(task: rightKneeRangeOfMotion) { reason, result in
            if reason == .completed, let res = result {
                processResult(res)
                scheduleManager.recordCompletion(of: .rightKneeROM)
            }
            showRightKneeROM = false
            BackgroundKeeper.shared.stopAudioLoop()
        }
    }

    // Formats a TimeInterval into "Xd Yh Zm", "Yh Zm", or "Zm"
    private func formatInterval(_ secs: TimeInterval) -> String {
        let totalMinutes = Int(secs) / 60
        let days    = totalMinutes / (24 * 60)
        let hours   = (totalMinutes % (24 * 60)) / 60
        let minutes = totalMinutes % 60

        var components: [String] = []
        if days > 0 { components.append("\(days)d") }
        if hours > 0 { components.append("\(hours)h") }
        if minutes > 0 || components.isEmpty { components.append("\(minutes)m") }
        return components.joined(separator: " ")
    }
}

// MARK: - Button Style
struct FilledButtonStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct TestsView: View {
    @EnvironmentObject var scheduleManager: ScheduleManager
    @Binding var showShortWalkTask: Bool
    @Binding var show6MWTT: Bool
    @Binding var show2MWTT: Bool
    @Binding var showLeftKneeROM: Bool
    @Binding var showRightKneeROM: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Select a Test")
                .font(.title2)
                .padding(.top, 20)

            if scheduleManager.gaitRaw != ScheduleManager.Frequency.none.rawValue {
                Button("Gait and Balance") {
                    BackgroundKeeper.shared.startAudioLoop()
                    showShortWalkTask = true
                }
                .buttonStyle(FilledButtonStyle(color: .green))
            }
            if scheduleManager.sixRaw != ScheduleManager.Frequency.none.rawValue {
                Button("6MWT") {
                    BackgroundKeeper.shared.startAudioLoop()
                    show6MWTT = true
                }
                .buttonStyle(FilledButtonStyle(color: .green))
            }
            if scheduleManager.twoRaw != ScheduleManager.Frequency.none.rawValue {
                Button("2MWT") {
                    BackgroundKeeper.shared.startAudioLoop()
                    show2MWTT = true
                }
                .buttonStyle(FilledButtonStyle(color: .green))
            }
            if scheduleManager.leftKneeROMRaw != ScheduleManager.Frequency.none.rawValue {
                Button("Left Knee ROM") {
                    BackgroundKeeper.shared.startAudioLoop()
                    showLeftKneeROM = true
                }
                .buttonStyle(FilledButtonStyle(color: .green))
            }
            if scheduleManager.rightKneeROMRaw != ScheduleManager.Frequency.none.rawValue {
                Button("Right Knee ROM") {
                    BackgroundKeeper.shared.startAudioLoop()
                    showRightKneeROM = true
                }
                .buttonStyle(FilledButtonStyle(color: .green))
            }

            Spacer()
        }
        .padding(.horizontal, 40)
        .navigationBarTitle("Tests", displayMode: .inline)
    }
}

