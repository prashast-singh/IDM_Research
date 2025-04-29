//
//  informedConsentStep.swift
//  IDM Research
//
//  Created by Prashast Singh on 15.04.25.
//

import ResearchKit
import ResearchKitUI
import HealthKit

struct informedConsentStepStruct{
    
    
    static var informedConsentStepExample: ORKInstructionStep {
        let instructionStep = ORKInstructionStep(identifier: String(describing: ConsentStepIdentifier.informedConsentInstructionStep))
        instructionStep.iconImage = UIImage(systemName: "doc.text.magnifyingglass")
        instructionStep.title = "Before You Join"
        
        let sharingHealthDataBodyItem = ORKBodyItem(text: "The study will ask you to share some of your Health data.",
                                                    detailText: nil,
                                                    image: UIImage(systemName: "heart.fill"),
                                                    learnMoreItem: nil,
                                                    bodyItemStyle: .image,
                                                    useCardStyle: false,
                                                    alignImageToTop: true)
        
        let completingTasksBodyItem = ORKBodyItem(text: "You will be asked to complete various tasks over the duration of the study.",
                                                  detailText: nil,
                                                  image: UIImage(systemName: "checkmark.circle.fill"),
                                                  learnMoreItem: nil,
                                                  bodyItemStyle: .image,
                                                  useCardStyle: false,
                                                  alignImageToTop: true)
        
        let signatureBodyItem = ORKBodyItem(text: "Before joining, we will ask you to sign an informed consent document.",
                                            detailText: nil,
                                            image: UIImage(systemName: "signature"),
                                            learnMoreItem: nil,
                                            bodyItemStyle: .image,
                                            useCardStyle: false,
                                            alignImageToTop: true)
        
        let secureDataBodyItem = ORKBodyItem(text: "Your data is kept private and secure.",
                                             detailText: nil,
                                             image: UIImage(systemName: "lock.fill"),
                                             learnMoreItem: nil,
                                             bodyItemStyle: .image,
                                             useCardStyle: false,
                                             alignImageToTop: true)
        
        instructionStep.bodyItems = [
            sharingHealthDataBodyItem,
            completingTasksBodyItem,
            signatureBodyItem,
            secureDataBodyItem
        ]
        
        return instructionStep
    }
    
    static var webViewStepExample: ORKWebViewStep {
        let instructionSteps = [
            informedConsentStepStruct.informedConsentStepExample
        ]
        
        let webViewStep = ORKWebViewStep(identifier: String(describing: ConsentStepIdentifier.webViewStep), instructionSteps: instructionSteps)
        webViewStep.showSignatureAfterContent = true
        return webViewStep
    }
    
    static var requestPermissionsStepExample: ORKRequestPermissionsStep {
        let healthKitTypesToWrite: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
        ]
        
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .walkingStepLength)!,
            HKObjectType.quantityType(forIdentifier: .walkingSpeed)!,
            HKObjectType.quantityType(forIdentifier: .walkingDoubleSupportPercentage)!,
            HKObjectType.quantityType(forIdentifier: .walkingAsymmetryPercentage)!,
            
            ]
        
        let healthKitPermissionType = ORKHealthKitPermissionType(sampleTypesToWrite: healthKitTypesToWrite, objectTypesToRead: healthKitTypesToRead)
        
        let requestPermissionsStep = ORKRequestPermissionsStep(identifier: String(describing: ConsentStepIdentifier.healthKitPermission), permissionTypes: [healthKitPermissionType])
        requestPermissionsStep.title = "Health Data Request"
        requestPermissionsStep.text = "Please review the health data types below and enable sharing to contribute to the study."
        
        return requestPermissionsStep
    }
   
}

