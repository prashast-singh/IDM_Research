//
//  CreateActiveTaskSteps.swift
//  IDM Research
//
//  Created by Prashast Singh on 22.04.25.
//

import ResearchKit
import ResearchKitUI
import SwiftUI
import CoreMotion
import ResearchKitActiveTask_Private
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
    return ORKOrderedTask.shortWalk(withIdentifier: "shortWalk", intendedUseDescription: "Use a clear, level 20 m corridor with firm flooring. Have a chair nearby in case the participant needs to pause. Confirm shoes are flat‑soled and clothing doesn’t impede movement.", numberOfStepsPerLeg: 20, restDuration: 20, options: [])
}

 var timedWalkWithTurnAroundTask: ORKTask {
    return ORKOrderedTask.timedWalk(withIdentifier: "TimedWalk", intendedUseDescription: "timed walk description", distanceInMeters: 10.0, timeLimit: 25.0, turnAroundTimeLimit: 5.0, includeAssistiveDeviceForm: true, options: [])
}

var rightKneeRangeOfMotion: ORKTask {
    return ORKOrderedTask.kneeRangeOfMotionTask(withIdentifier: "rightKneeROM", limbOption: .right, intendedUseDescription: "", options: [])
}

var leftKneeRangeOfMotion: ORKTask {
    return ORKOrderedTask.kneeRangeOfMotionTask(withIdentifier: "lefttKneeROM", limbOption: .left, intendedUseDescription: "", options: [])
}


var sixMinWalkTask: ORKTask{
    return ORKOrderedTask.sixMinuteWalk(withIdentifier: "6MWT", intendedUseDescription: "6mwt", options: [])
}


var twoMinuteWalkTest: ORKOrderedTask {
    return createTwoMinuteWalkTestTask()
}


func createTwoMinuteWalkTestTask() -> ORKOrderedTask {
    var steps = [ORKStep]()

    // Step 1: Introduction
    let introStep = ORKInstructionStep(identifier: "intro")
    introStep.title = "Two-Minute Walk Test"
    introStep.text = "Please walk at a comfortable, steady pace for 2 minutes. Try to walk in a straight path if possible."
    steps.append(introStep)

    // Step 2: Countdown (5 seconds)
    let countdownStep = ORKCountdownStep(identifier: "countdown")
    countdownStep.stepDuration = 5
    countdownStep.text = "Get ready to begin in..."
    steps.append(countdownStep)

    // Step 3: Fitness Step (uses MPedometer internally)
    let fitnessStep = ORKFitnessStep(identifier: "fitnessStep")
    fitnessStep.title = "Start Walking"
    fitnessStep.text = "Walk now. The timer will run for 2 minutes."
    fitnessStep.stepDuration = 120 // 2 minutes

    fitnessStep.spokenInstruction = fitnessStep.text
    fitnessStep.recorderConfigurations = [ORKPedometerRecorderConfiguration(identifier: "pedometer")]
    fitnessStep.shouldContinueOnFinish = true
    fitnessStep.isOptional = false
    fitnessStep.shouldStartTimerAutomatically = true
    fitnessStep.shouldVibrateOnStart = true
    fitnessStep.shouldVibrateOnFinish = true
    fitnessStep.shouldPlaySoundOnStart = true
    fitnessStep.shouldPlaySoundOnFinish = true
    fitnessStep.shouldSpeakRemainingTimeAtHalfway = true
    fitnessStep.shouldSpeakCountDown = true
    
    steps.append(fitnessStep)

    // Step 4: Device Motion Recorder Step (optional but powerful)
    let motionConfig = ORKDeviceMotionRecorderConfiguration(identifier: "motion", frequency: 50.0)

    let motionStep = ORKActiveStep(identifier: "motionRecorder")
    motionStep.title = "Recording Motion Data"
    motionStep.stepDuration = 120 // Must match fitness step
    motionStep.recorderConfigurations = [motionConfig]
    motionStep.shouldStartTimerAutomatically = true
    motionStep.shouldContinueOnFinish = true
   // steps.append(motionStep)

    // Step 5: Completion
    let completionStep = ORKCompletionStep(identifier: "completion")
    completionStep.title = "Test Complete"
    completionStep.text = "Thank you for completing the walk test!"
    steps.append(completionStep)

    return ORKOrderedTask(identifier: "TwoMinuteWalkTest", steps: steps)
}

