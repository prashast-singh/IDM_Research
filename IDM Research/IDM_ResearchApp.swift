//
//  IDM_ResearchApp.swift
//  IDM Research
//
//  Created by Prashast Singh on 02.04.25.
//

import SwiftUI

@main
struct IDM_ResearchApp: App {
    @StateObject private var scheduleManager = ScheduleManager()
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(scheduleManager)
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
