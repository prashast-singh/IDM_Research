//
//  ActiveTaskSteps.swift
//  IDM Research
//
//  Created by Prashast Singh on 22.04.25.
//

import ResearchKit
import ResearchKitUI
import SwiftUI
import Foundation
import ResearchKit_Private
import ResearchKitActiveTask
import ResearchKitActiveTask_Private
import ResearchKitUI

struct activeTaskSteps{
    static var instructionStep : ORKInstructionStep{
        let instructionStep = ORKInstructionStep(identifier: "active task instruction step")
        instructionStep.title = NSLocalizedString("Survey and Active task", comment: "")
        instructionStep.detailText = NSLocalizedString("Please answer the survey questions carefully and perform the active tasks after completing the questionnaire.", comment: "")
        return instructionStep
    }
    
    
    static var formStep1: ORKFormStep {
        let textChoices1: [ORKTextChoice] = [
            ORKTextChoice(text: "Never", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Monthly", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Weekly", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Daily", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Always", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices2: [ORKTextChoice] = [
            ORKTextChoice(text: "None", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Mild", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Moderate", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Severe", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Extreme", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]

        //PAIN QUESTIONS
        let textChoiceQuestion1 = NSLocalizedString("How often is your knee painful?", comment: "")
        let textChoiceQuestion2 = NSLocalizedString("Twisting/pivoting on your knee?", comment: "")
        let textChoiceQuestion3 = NSLocalizedString("Straightening knee fully?", comment: "")
        let textChoiceQuestion4 = NSLocalizedString("Bending knee fully?", comment: "")
        let textChoiceQuestion5 = NSLocalizedString("Walking on flat surface?", comment: "")
        let textChoiceQuestion6 = NSLocalizedString("Going up or down stairs?", comment: "")
        let textChoiceQuestion7 = NSLocalizedString("At night while in bed?", comment: "")
        let textChoiceQuestion8 = NSLocalizedString("Sitting or lying?", comment: "")
        let textChoiceQuestion9 = NSLocalizedString("Degree of Pain: Standing upright?", comment: "")
        
        
        let textChoiceAnswerFormat1 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices1)
        let textChoiceAnswerFormat2 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices2)
        
        let textChoiceFormItem1 = ORKFormItem(identifier: "KOOD form1 item1", text: textChoiceQuestion1, answerFormat: textChoiceAnswerFormat1)
        let textChoiceFormItem2 = ORKFormItem(identifier: "KOOD form1 item2", text: textChoiceQuestion2, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem3 = ORKFormItem(identifier: "KOOD form1 item3", text: textChoiceQuestion3, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem4 = ORKFormItem(identifier: "KOOD form1 item4", text: textChoiceQuestion4, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem5 = ORKFormItem(identifier: "KOOD form1 item5", text: textChoiceQuestion5, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem6 = ORKFormItem(identifier: "KOOD form1 item6", text: textChoiceQuestion6, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem7 = ORKFormItem(identifier: "KOOD form1 item7", text: textChoiceQuestion7, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem8 = ORKFormItem(identifier: "KOOD form1 item8", text: textChoiceQuestion8, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem9 = ORKFormItem(identifier: "KOOD form1 item9", text: textChoiceQuestion9, answerFormat: textChoiceAnswerFormat2)
        
        
     //   textChoiceFormItem1.learnMoreItem = self.learnMoreItem
        
        
        let textChoiceFormStep = ORKFormStep(identifier: "KOOD questionnaire pain", title: "Knee Injury and Osteoarthritis Outcome Score (KOOS) questionnaire", text: "Pain: What degree of pain have you experienced the last week when ?")
        
        textChoiceFormStep.formItems = [textChoiceFormItem1,textChoiceFormItem2,textChoiceFormItem3, textChoiceFormItem4, textChoiceFormItem5, textChoiceFormItem6, textChoiceFormItem7, textChoiceFormItem8, textChoiceFormItem9]
        
        return textChoiceFormStep
    }
    
    static var formStep2: ORKFormStep {
        let textChoices1: [ORKTextChoice] = [
            ORKTextChoice(text: "Never", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Monthly", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Weekly", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Daily", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Always", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices2: [ORKTextChoice] = [
            ORKTextChoice(text: "None", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Mild", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Moderate", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Severe", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Extreme", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices3: [ORKTextChoice] = [
            ORKTextChoice(text: "Never", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Rarely", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Sometime", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Often", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Always", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices4: [ORKTextChoice] = [
            ORKTextChoice(text: "Always", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Often", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Sometime", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Rarely", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Never", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices5: [ORKTextChoice] = [
            ORKTextChoice(text: "Not at all", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Mildly", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Moderately", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Severelly", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Totally", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoiceAnswerFormat1 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices1)
        let textChoiceAnswerFormat2 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices2)
        let textChoiceAnswerFormat3 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices3)
        let textChoiceAnswerFormat4 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices4)
        let textChoiceAnswerFormat5 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices5)

        //SYmptoms QUESTIONS
        let textChoiceQuestion1 = NSLocalizedString("How severe is your knee stiffness after first wakening in the morning?", comment: "")
        let textChoiceQuestion2 = NSLocalizedString("How severe is your knee stiffness after sitting, lying, or resting later in the day?", comment: "")
        let textChoiceQuestion3 = NSLocalizedString(" Do you have swelling in your knee?", comment: "")
        let textChoiceQuestion4 = NSLocalizedString("Do you feel grinding, hear clicking or any other type of noise when your knee moves?", comment: "")
        let textChoiceQuestion5 = NSLocalizedString("Does your knee catch or hang up when moving?", comment: "")
        let textChoiceQuestion6 = NSLocalizedString("Can you straighten your knee fully?", comment: "")
        let textChoiceQuestion7 = NSLocalizedString("Can you bend your knee fully?", comment: "")
        
        let textChoiceFormItem1 = ORKFormItem(identifier: "KOOD form2 item1", text: textChoiceQuestion1, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem2 = ORKFormItem(identifier: "KOOD form2 item2", text: textChoiceQuestion2, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem3 = ORKFormItem(identifier: "KOOD form2 item3", text: textChoiceQuestion3, answerFormat: textChoiceAnswerFormat3)
        let textChoiceFormItem4 = ORKFormItem(identifier: "KOOD form2 item4", text: textChoiceQuestion4, answerFormat: textChoiceAnswerFormat3)
        let textChoiceFormItem5 = ORKFormItem(identifier: "KOOD form2 item5", text: textChoiceQuestion5, answerFormat: textChoiceAnswerFormat3)
        let textChoiceFormItem6 = ORKFormItem(identifier: "KOOD form2 item6", text: textChoiceQuestion6, answerFormat: textChoiceAnswerFormat4)
        let textChoiceFormItem7 = ORKFormItem(identifier: "KOOD form2 item7", text: textChoiceQuestion7, answerFormat: textChoiceAnswerFormat4)
        
        
        
        
        let textChoiceFormStep = ORKFormStep(identifier: "KOOD questionnaire symptoms", title: "Knee Injury and Osteoarthritis Outcome Score (KOOS) questionnaire", text: "Symptoms")
        
        textChoiceFormStep.formItems = [textChoiceFormItem1,textChoiceFormItem2,textChoiceFormItem3, textChoiceFormItem4, textChoiceFormItem5, textChoiceFormItem6, textChoiceFormItem7]
        
        return textChoiceFormStep
    }
    
    static var formStep3: ORKFormStep {
        
        let textChoices2: [ORKTextChoice] = [
            ORKTextChoice(text: "None", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Mild", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Moderate", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Severe", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Extreme", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        
        
        
        let textChoiceAnswerFormat2 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices2)
        

        // ADL question texts for KOOS form, indexed from 1 to 17
        let textChoiceQuestion1 = NSLocalizedString("Descending stairs", comment: "")
        let textChoiceQuestion2 = NSLocalizedString("Ascending stairs", comment: "")
        let textChoiceQuestion3 = NSLocalizedString("Rising from sitting", comment: "")
        let textChoiceQuestion4 = NSLocalizedString("Standing", comment: "")
        let textChoiceQuestion5 = NSLocalizedString("Bending to floor/picking up an object", comment: "")
        let textChoiceQuestion6 = NSLocalizedString("Walking on flat surface", comment: "")
        let textChoiceQuestion7 = NSLocalizedString("Getting in/out of car", comment: "")
        let textChoiceQuestion8 = NSLocalizedString("Going shopping", comment: "")
        let textChoiceQuestion9 = NSLocalizedString("Putting on socks/stockings", comment: "")
        let textChoiceQuestion10 = NSLocalizedString("Rising from bed", comment: "")
        let textChoiceQuestion11 = NSLocalizedString("Taking off socks/stockings", comment: "")
        let textChoiceQuestion12 = NSLocalizedString("Lying in bed (turning over, maintaining knee position)", comment: "")
        let textChoiceQuestion13 = NSLocalizedString("Getting in/out of bath", comment: "")
        let textChoiceQuestion14 = NSLocalizedString("Sitting", comment: "")
        let textChoiceQuestion15 = NSLocalizedString("Getting on/off toilet", comment: "")
        let textChoiceQuestion16 = NSLocalizedString("Heavy domestic duties (shovelling, scrubbing floors, etc)", comment: "")
        let textChoiceQuestion17 = NSLocalizedString("Light domestic duties (cooking, dusting, etc)", comment: "")

        
        // Create ORKFormItem for each ADL question (1–17) using textChoiceAnswerFormat2
        let textChoiceFormItem1  = ORKFormItem(identifier: "KOOS_form3_item1",  text: textChoiceQuestion1,  answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem2  = ORKFormItem(identifier: "KOOS_form3_item2",  text: textChoiceQuestion2,  answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem3  = ORKFormItem(identifier: "KOOS_form3_item3",  text: textChoiceQuestion3,  answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem4  = ORKFormItem(identifier: "KOOS_form3_item4",  text: textChoiceQuestion4,  answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem5  = ORKFormItem(identifier: "KOOS_form3_item5",  text: textChoiceQuestion5,  answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem6  = ORKFormItem(identifier: "KOOS_form3_item6",  text: textChoiceQuestion6,  answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem7  = ORKFormItem(identifier: "KOOS_form3_item7",  text: textChoiceQuestion7,  answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem8  = ORKFormItem(identifier: "KOOS_form3_item8",  text: textChoiceQuestion8,  answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem9  = ORKFormItem(identifier: "KOOS_form3_item9",  text: textChoiceQuestion9,  answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem10 = ORKFormItem(identifier: "KOOS_form3_item10", text: textChoiceQuestion10, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem11 = ORKFormItem(identifier: "KOOS_form3_item11", text: textChoiceQuestion11, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem12 = ORKFormItem(identifier: "KOOS_form3_item12", text: textChoiceQuestion12, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem13 = ORKFormItem(identifier: "KOOS_form3_item13", text: textChoiceQuestion13, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem14 = ORKFormItem(identifier: "KOOS_form3_item14", text: textChoiceQuestion14, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem15 = ORKFormItem(identifier: "KOOS_form3_item15", text: textChoiceQuestion15, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem16 = ORKFormItem(identifier: "KOOS_form3_item16", text: textChoiceQuestion16, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem17 = ORKFormItem(identifier: "KOOS_form3_item17", text: textChoiceQuestion17, answerFormat: textChoiceAnswerFormat2)

        
        
        
        
        let textChoiceFormStep = ORKFormStep(identifier: "KOOD questionnaire activities", title: "Knee Injury and Osteoarthritis Outcome Score (KOOS) questionnaire", text: "Activities of daily living: What difficulty have you experienced the last week…?")
        
        textChoiceFormStep.formItems = [
            textChoiceFormItem1,
            textChoiceFormItem2,
            textChoiceFormItem3,
            textChoiceFormItem4,
            textChoiceFormItem5,
            textChoiceFormItem6,
            textChoiceFormItem7,
            textChoiceFormItem8,
            textChoiceFormItem9,
            textChoiceFormItem10,
            textChoiceFormItem11,
            textChoiceFormItem12,
            textChoiceFormItem13,
            textChoiceFormItem14,
            textChoiceFormItem15,
            textChoiceFormItem16,
            textChoiceFormItem17
        ]

        
        return textChoiceFormStep
    }
    
    
    
    
    
    
    static var formStep4: ORKFormStep {
        let textChoices1: [ORKTextChoice] = [
            ORKTextChoice(text: "Never", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Monthly", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Weekly", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Daily", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Always", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices2: [ORKTextChoice] = [
            ORKTextChoice(text: "None", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Mild", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Moderate", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Severe", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Extreme", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices3: [ORKTextChoice] = [
            ORKTextChoice(text: "Never", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Rarely", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Sometime", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Often", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Always", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices4: [ORKTextChoice] = [
            ORKTextChoice(text: "Always", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Often", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Sometime", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Rarely", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Never", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices5: [ORKTextChoice] = [
            ORKTextChoice(text: "Not at all", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Mildly", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Moderately", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Severelly", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Totally", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
       
        let textChoiceAnswerFormat2 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices2)
        

        // Sport & recreation question texts for KOOS form (Sp1–Sp5)
        let textChoiceQuestion1 = NSLocalizedString("Squatting", comment: "")
        let textChoiceQuestion2 = NSLocalizedString("Running", comment: "")
        let textChoiceQuestion3 = NSLocalizedString("Jumping", comment: "")
        let textChoiceQuestion4 = NSLocalizedString("Turning/twisting on your injured knee", comment: "")
        let textChoiceQuestion5 = NSLocalizedString("Kneeling", comment: "")

        
        let textChoiceFormItem1 = ORKFormItem(identifier: "KOOD form4 item1", text: textChoiceQuestion1, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem2 = ORKFormItem(identifier: "KOOD form4 item2", text: textChoiceQuestion2, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem3 = ORKFormItem(identifier: "KOOD form4 item3", text: textChoiceQuestion3, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem4 = ORKFormItem(identifier: "KOOD form4 item4", text: textChoiceQuestion4, answerFormat: textChoiceAnswerFormat2)
        let textChoiceFormItem5 = ORKFormItem(identifier: "KOOD form4 item5", text: textChoiceQuestion5, answerFormat: textChoiceAnswerFormat2)
        
        
        
        let textChoiceFormStep = ORKFormStep(identifier: "KOOD questionnaire sports & recreation", title: "Knee Injury and Osteoarthritis Outcome Score (KOOS) questionnaire", text: "Sport and recreation function: What difficulty have you experienced the last week…?")
        
        textChoiceFormStep.formItems = [textChoiceFormItem1,textChoiceFormItem2,textChoiceFormItem3, textChoiceFormItem4, textChoiceFormItem5]
        
        return textChoiceFormStep
    }
    
    
    static var formStep5: ORKFormStep {
        let textChoices1: [ORKTextChoice] = [
            ORKTextChoice(text: "Never", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Monthly", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Weekly", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Daily", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Always", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices2: [ORKTextChoice] = [
            ORKTextChoice(text: "None", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Mild", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Moderate", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Severe", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Extreme", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices3: [ORKTextChoice] = [
            ORKTextChoice(text: "Never", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Rarely", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Sometime", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Often", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Always", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices4: [ORKTextChoice] = [
            ORKTextChoice(text: "Always", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Often", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Sometime", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Rarely", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Never", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoices5: [ORKTextChoice] = [
            ORKTextChoice(text: "Not at all", detailText: "", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Mildly", detailText: "", value: 2 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Moderately", detailText: "", value: 3 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Severelly", detailText: "", value: 4 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Totally", detailText: "", value: 5 as NSNumber, exclusive: false),
        ]
        
        let textChoiceAnswerFormat1 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices1)
        let textChoiceAnswerFormat2 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices2)
        let textChoiceAnswerFormat3 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices3)
        let textChoiceAnswerFormat4 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices4)
        let textChoiceAnswerFormat5 = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: textChoices5)

        // Quality of Life question texts for KOOS form (Q1–Q4)
        let textChoiceQuestion1 = NSLocalizedString("How often are you aware of your knee problems?", comment: "")
        let textChoiceQuestion2 = NSLocalizedString("Have you modified your lifestyle to avoid potentially damaging activities to your knee?", comment: "")
        let textChoiceQuestion3 = NSLocalizedString("How troubled are you with lack of confidence in your knee?", comment: "")
        let textChoiceQuestion4 = NSLocalizedString("In general, how much difficulty do you have with your knee?", comment: "")

        
        let textChoiceFormItem1 = ORKFormItem(identifier: "KOOD form5 item1", text: textChoiceQuestion1, answerFormat: textChoiceAnswerFormat1)
        let textChoiceFormItem2 = ORKFormItem(identifier: "KOOD form5 item2", text: textChoiceQuestion2, answerFormat: textChoiceAnswerFormat5)
        let textChoiceFormItem3 = ORKFormItem(identifier: "KOOD form5 item3", text: textChoiceQuestion3, answerFormat: textChoiceAnswerFormat5)
        let textChoiceFormItem4 = ORKFormItem(identifier: "KOOD form5 item4", text: textChoiceQuestion4, answerFormat: textChoiceAnswerFormat2)
    
        

        let textChoiceFormStep = ORKFormStep(identifier: "KOOD questionnaire Knee-related quality of life", title: "Knee Injury and Osteoarthritis Outcome Score (KOOS) questionnaire", text: "Knee-related quality of life")
        
        textChoiceFormStep.formItems = [textChoiceFormItem1,textChoiceFormItem2,textChoiceFormItem3, textChoiceFormItem4]
        
        return textChoiceFormStep
    }
    static var summaryStep : ORKInstructionStep{
        let summaryStep = ORKInstructionStep(identifier: "questionnaire summary step")
        summaryStep.title = NSLocalizedString("Thanks", comment: "")
        summaryStep.text = NSLocalizedString("Thank you for participating in IDM KOOS survey. Press done to perform active task", comment: "")
        return summaryStep
    }
    
    

    
private  static  var learnMoreItem: ORKLearnMoreItem {
        let learnMoreInstructionStep = ORKLearnMoreInstructionStep(identifier: "LearnMoreInstructionStep")
        learnMoreInstructionStep.title = NSLocalizedString("Learn more title", comment: "nknk")
        learnMoreInstructionStep.text = NSLocalizedString("Learn more text", comment: "nknnk")
        let learnMoreItem = ORKLearnMoreItem(text: nil, learnMoreInstructionStep: learnMoreInstructionStep)
        
        return learnMoreItem
    }
}
