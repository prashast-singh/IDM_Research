//
//  ConsentMainView.swift
//  IDM Research
//
//  Created by Prashast Singh on 02.04.25.
//

import ResearchKit
import ResearchKitUI
import SwiftUI
import Foundation
// Welcome page.
var consentTask: ORKOrderedTask{
    func createConsentSteps() -> [ORKStep]{
        let welcomeStep = ORKInstructionStep(identifier: String(describing: ConsentStepIdentifier.consentWelcomeInstructionStep))
        welcomeStep.iconImage = UIImage(systemName: "hand.wave")
        welcomeStep.title = "Welcome!"
        welcomeStep.detailText = "Thank you for joining our IDM research study. Tap Next to learn more before signing up."
        
        // Before You Join page.
        
        let beforeYouJoinStep = informedConsentStepStruct.informedConsentStepExample
        
        
        //Creating document for consent signature
        
        let consentSignatureStep = informedConsentStepStruct.webViewStepExample
        
        //Creating a consent review(signing) step
        
        
        let healthKitConsentStep = informedConsentStepStruct.requestPermissionsStepExample
        
        
        
        
        return [welcomeStep, beforeYouJoinStep, consentSignatureStep, healthKitConsentStep]
    }
    return ORKOrderedTask(identifier: "consentTask", steps: createConsentSteps())
}

