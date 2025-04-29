//
//  CreateActiveTaskSteps.swift
//  IDM Research
//
//  Created by Prashast Singh on 22.04.25.
//

import ResearchKit
import ResearchKitUI
import SwiftUI
import Foundation
// Welcome page.
var activeTask: ORKOrderedTask{
    func createActiveTaskSteps() -> [ORKStep]{
        
        
        let instructionStep = activeTaskSteps.instructionStep
        
        let formStep1 = activeTaskSteps.formStep1
        let formStep2 = activeTaskSteps.formStep2
        let formStep3 = activeTaskSteps.formStep3
        let formStep4 = activeTaskSteps.formStep4
        let fromStep5 = activeTaskSteps.formStep5
        
        let summaryStep = activeTaskSteps.summaryStep
        
        
        return [instructionStep, formStep1, formStep2, formStep3, formStep4, fromStep5, summaryStep]
    }
    return ORKOrderedTask(identifier: "activeTask", steps: createActiveTaskSteps())
}

var shortWalkTask: ORKTask {
    return ORKOrderedTask.shortWalk(withIdentifier: "short walk", intendedUseDescription: "Use a clear, level 20 m corridor with firm flooring. Have a chair nearby in case the participant needs to pause. Confirm shoes are flat‑soled and clothing doesn’t impede movement.", numberOfStepsPerLeg: 20, restDuration: 20, options: [])
}
