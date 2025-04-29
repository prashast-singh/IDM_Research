//
//  MainView.swift
//  IDM Research
//
//  Created by Prashast Singh on 16.04.25.
//

import SwiftUI

struct MainView: View {
    @State private var showConsent = false
    @State private var showActiveTask = false
    @State private var showingShortWalkTask = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("IDM Research")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            Spacer()

            Button("View Consent") {
                showConsent = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)

            Button("Complete Task") {
                showActiveTask = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)

            Spacer()
        }
        .padding(.horizontal, 40)
        .fullScreenCover(isPresented: $showConsent) {
            ConsentView(isPresented: $showConsent)
        }
        .fullScreenCover(isPresented: $showActiveTask) {
            TaskView(task: activeTask) { reason in
                if reason == .completed {
                    showingShortWalkTask = true
                }
                showActiveTask = false
            }
        }
        .fullScreenCover(isPresented: $showingShortWalkTask) {
            TaskView(task: shortWalkTask) { reason in
                print("Short Walk Task finished with: \(reason)")
                showingShortWalkTask = false
            }
        }
    }
}
