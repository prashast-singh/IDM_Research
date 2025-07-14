//
//  RootView.swift
//  IDM Research
//
//  Created by Prashast Singh on 23.04.25.
//

import Foundation
import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Tasks", systemImage: "list.bullet.rectangle")
                }

            ResultsView()
                .tabItem {
                    Label("Results", systemImage: "bubble.left.and.bubble.right.fill")
                }
            
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar.badge.clock")
                }
        }
    }
}
