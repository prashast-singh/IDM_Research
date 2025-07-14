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
import ResearchKitActiveTask
import CoreData


struct TaskView: UIViewControllerRepresentable {
    let task: ORKTask
    let onFinish: (ORKTaskFinishReason, ORKTaskResult?) -> Void

    func makeUIViewController(context: Context) -> ORKTaskViewController {
        UIApplication.shared.isIdleTimerDisabled = true
        let vc = ORKTaskViewController(task: task, taskRun: nil)
        vc.delegate = context.coordinator

        // 1) Pick (or create) a folder under Documents:
        let docs = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first!
        let outDir = docs.appendingPathComponent(task.identifier, isDirectory: true)
        try? FileManager.default.createDirectory(
            at: outDir,
            withIntermediateDirectories: true,
            attributes: nil
        )

        // 2) Assign it so RK can write its JSON recorder files there:
        vc.outputDirectory = outDir

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
            if let error = error {
                   // Handle the error appropriately, maybe log or display an alert
                   print("Task finished with error manual: \(error.localizedDescription)")
               }
            
            let result = taskViewController.result
            UIApplication.shared.isIdleTimerDisabled = false
                self.onFinish(reason, result)
            
            
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
        var currentY: CGFloat = 20.0 // Start top margin

        context.beginPage()

        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
        ]

        let contentWidth = pageRect.width - 40.0  // 20pt margin on each side
        let text = content as NSString
        let maxTextHeight = pageHeight - 40.0  // Account for top and bottom margins

        let textSize = text.boundingRect(with: CGSize(width: contentWidth, height: maxTextHeight),
                                         options: .usesLineFragmentOrigin,
                                         attributes: attributes,
                                         context: nil).size

        if textSize.height > maxTextHeight {
            let numberOfPages = Int(ceil(textSize.height / maxTextHeight))
            for i in 0..<numberOfPages {
                context.beginPage()
                let currentContent = text.substring(with: NSRange(location: i * Int(maxTextHeight), length: Int(maxTextHeight)))
                currentContent.draw(in: CGRect(x: 20, y: currentY, width: contentWidth, height: textSize.height))
                currentY += textSize.height
            }
        } else {
            content.draw(in: CGRect(x: 20, y: currentY, width: contentWidth, height: textSize.height), withAttributes: attributes)
        }
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
    var formText = "📝 Form Responses:\n"
    var walkText = "🚶 Short Walk Data:\n"

    // Identify task type
    let taskIdentifier = taskResult.identifier
    let now = Date()
    var walkSteps: Int? = nil
    var kneeAngle: Double? = nil

    for stepResult in taskResult.results ?? [] {
        guard let stepResult = stepResult as? ORKStepResult else { continue }

        for item in stepResult.results ?? [] {
            switch item {
            case let choice as ORKChoiceQuestionResult:
                let answers = choice.choiceAnswers?.compactMap { "\($0)" }.joined(separator: ", ") ?? "No answer"
                formText += "\(item.identifier): \(answers)\n"

            case let text as ORKTextQuestionResult:
                let answer = text.textAnswer ?? "No answer"
                formText += "\(item.identifier): \(answer)\n"

            case let numeric as ORKNumericQuestionResult:
                let answer = numeric.numericAnswer?.stringValue ?? "No answer"
                formText += "\(item.identifier): \(answer)\n"

            case let date as ORKDateQuestionResult:
                let answer = date.dateAnswer?.description ?? "No answer"
                formText += "\(item.identifier): \(answer)\n"
                
            case let scale as ORKScaleQuestionResult:
                let answer = scale.scaleAnswer?.description ?? "No answer"
                formText += "\(item.identifier): \(answer)\n"
                
            case let timedWalk as ORKTimedWalkResult:
                walkText += "\(item.identifier):\n"
                walkText += "- Distance: \(timedWalk.distanceInMeters) m\n"
                walkText += "- Duration: \(timedWalk.duration) s\n"
                walkText += "- Time Limit: \(timedWalk.timeLimit) s\n"
                // Try to extract steps from userInfo if available
                if let steps = timedWalk.userInfo?["numberOfSteps"] as? Int {
                    walkSteps = steps
                }

            case let file as ORKFileResult:
                let filename = file.fileURL?.lastPathComponent ?? "Unknown file"
                walkText += "\(item.identifier): File - \(filename)\n"

            case let rom as ORKRangeOfMotionResult:
                kneeAngle = rom.range

            default:
                formText += "\(item.identifier): [Unhandled result type]\n"
            }
        }
    }

    // Save as PDFs
    _ = createPDF(from: formText, fileName: "FormResults")
    _ = createPDF(from: walkText, fileName: "ShortWalkResults")

    // Save persistent results for specific tasks (using correct identifiers)
    let context = PersistenceController.shared.viewContext
    if ["6MWT", "TwoMinuteWalkTest", "shortWalk"].contains(taskIdentifier), let steps = walkSteps {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "WalkResult", into: context)
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(now, forKey: "date")
        entity.setValue(taskIdentifier, forKey: "taskType")
        entity.setValue(Int64(steps), forKey: "steps")
        try? context.save()
    }
    if ["lefttKneeROM", "rightKneeROM"].contains(taskIdentifier), let angle = kneeAngle {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "KneeROMResult", into: context)
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(now, forKey: "date")
        entity.setValue(taskIdentifier, forKey: "taskType")
        entity.setValue(angle, forKey: "angle")
        try? context.save()
    }
}
