//
//  ActiveTaskController.swift
//  IDM Research
//
//  Created by Prashast Singh on 22.04.25.
//

//
//  ActiveTaskController.swift
//  IDM Research
//
//  Created by Prashast Singh on 22.04.25.
//

import SwiftUI
import ResearchKit
import ResearchKitUI

struct TaskView: UIViewControllerRepresentable {
    let task: ORKTask
    let onFinish: (ORKTaskFinishReason, ORKTaskResult?) -> Void

    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let vc = ORKTaskViewController(task: task, taskRun: nil)
        vc.delegate = context.coordinator
        vc.modalPresentationStyle = .fullScreen
        return vc
    }

    func updateUIViewController(_ uiViewController: ORKTaskViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(onFinish: onFinish)
    }

    class Coordinator: NSObject, ORKTaskViewControllerDelegate {
        let onFinish: (ORKTaskFinishReason, ORKTaskResult?) -> Void

        init(onFinish: @escaping (ORKTaskFinishReason, ORKTaskResult?) -> Void) {
            self.onFinish = onFinish
        }

        func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskFinishReason, error: Error?) {
            let result = taskViewController.result
            taskViewController.dismiss(animated: true) {
                self.onFinish(reason, result)
            }
        }
    }
}

func createPDF(from content: String, fileName: String) -> URL? {
    let pdfMetaData = [
        kCGPDFContextCreator: "IDM Research",
        kCGPDFContextAuthor: "ResearchKit Task",
        kCGPDFContextTitle: fileName
    ]

    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]

    let pageWidth = 8.5 * 72.0
    let pageHeight = 11 * 72.0
    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
    let data = renderer.pdfData { context in
        context.beginPage()
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
        ]
        content.draw(in: pageRect.insetBy(dx: 20, dy: 20), withAttributes: attributes)
    }

    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("\(fileName).pdf")

    do {
        try data.write(to: url)
        print("Saved PDF to \(url)")
        return url
    } catch {
        print("Could not save PDF: \(error)")
        return nil
    }
}

func processResult(_ taskResult: ORKTaskResult) {
    var formText = "Form Responses:\n"
    var walkText = "Short Walk Results:\n"

    for result in taskResult.results ?? [] {
        if let stepResult = result as? ORKStepResult {
            for item in stepResult.results ?? [] {

                if let choice = item as? ORKChoiceQuestionResult {
                    let answer = choice.choiceAnswers?.compactMap { "\($0)" }.joined(separator: ", ") ?? "No answer"
                    formText += "\(item.identifier): \(answer)\n"
                }

                if let scale = item as? ORKScaleQuestionResult {
                    let value = scale.scaleAnswer?.stringValue ?? "No answer"
                    formText += "\(item.identifier): \(value)\n"
                }

                if let text = item as? ORKTextQuestionResult {
                    let value = text.textAnswer ?? "No answer"
                    formText += "\(item.identifier): \(value)\n"
                }
            }
        }

        if let walkStep = result as? ORKWalkStepResult {
            if let steps = walkStep.numberOfSteps {
                walkText += "Steps: \(steps)\n"
            }
            if let speed = walkStep.averageSpeed {
                walkText += "Average Speed: \(speed) m/s\n"
            }
            if let stride = walkStep.strideLength {
                walkText += "Stride Length: \(stride) m\n"
            }
        }
    }

    // Generate PDFs
    _ = createPDF(from: formText, fileName: "FormResults")
    _ = createPDF(from: walkText, fileName: "ShortWalkResults")
}
