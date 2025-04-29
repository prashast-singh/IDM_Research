//
//  ConsentController.swift
//  IDM Research
//
//  Created by Prashast Singh on 08.04.25.
//
import SwiftUI
import ResearchKit
import ResearchKitUI

struct ConsentView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let taskViewController = ORKTaskViewController(task: consentTask, taskRun: nil)
        // Set the coordinator as delegate
        taskViewController.delegate = context.coordinator
        return taskViewController
    }

    func updateUIViewController(_ uiViewController: ORKTaskViewController, context: Context) {
        // No updates needed here in this example.
    }
    
    // Create and return the coordinator which acts as the delegate.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Coordinator class conforming to ORKTaskViewControllerDelegate
    class Coordinator: NSObject, ORKTaskViewControllerDelegate {
        var parent: ConsentView
        
        init(_ parent: ConsentView) {
            self.parent = parent
        }
        
        // This method is called when the task finishes, whether by cancel, completion, or error.
        func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskFinishReason, error: Error?) {
            // You can add logic here to differentiate behavior based on `reason`
            // For example, checking if the user cancelled:
            if reason == .discarded {
                // Handle cancellation if needed
            }
            // Dismiss the task view by updating the binding.
            parent.isPresented = false
        }
    }
}

