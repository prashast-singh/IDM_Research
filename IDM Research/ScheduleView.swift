//  ScheduleView.swift
//  IDM Research

import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var scheduleManager: ScheduleManager

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Questionnaire")) {
                    Picker("KOOS", selection: $scheduleManager.questionnaireRaw) {
                        ForEach(ScheduleManager.Frequency.allCases) { freq in
                            Text(freq.rawValue).tag(freq.rawValue)
                        }
                    }
                }

                Section(header: Text("Tests")) {
                    Picker("Gait & Balance", selection: $scheduleManager.gaitRaw) {
                        ForEach(ScheduleManager.Frequency.allCases) { freq in
                            Text(freq.rawValue).tag(freq.rawValue)
                        }
                    }

                    Picker("6MWT", selection: $scheduleManager.sixRaw) {
                        ForEach(ScheduleManager.Frequency.allCases) { freq in
                            Text(freq.rawValue).tag(freq.rawValue)
                        }
                    }

                    Picker("2MWT", selection: $scheduleManager.twoRaw) {
                        ForEach(ScheduleManager.Frequency.allCases) { freq in
                            Text(freq.rawValue).tag(freq.rawValue)
                        }
                    }
                    
                    Picker("Left Knee ROM", selection: $scheduleManager.leftKneeROMRaw) {
                                            ForEach(ScheduleManager.Frequency.allCases) { freq in
                                                Text(freq.rawValue).tag(freq.rawValue)
                        }
                    }

                    Picker("Right Knee ROM", selection: $scheduleManager.rightKneeROMRaw) {
                                            ForEach(ScheduleManager.Frequency.allCases) { freq in
                                                Text(freq.rawValue).tag(freq.rawValue)
                        }
                    }

                    
                    
                }
            }
            .navigationBarTitle("Schedule", displayMode: .inline)
        }
    }
}

