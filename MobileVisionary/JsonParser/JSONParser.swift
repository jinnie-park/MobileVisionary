//
//  JsonParser.swift
//  MobileVisionary
//
//  Created by Ashley Koo on 8/7/18.
//  Copyright © 2018 All rights reserved.
//


import Foundation
import SwiftyJSON


class JSONParser : NSObject {
    
    func analyzeResults(_ dataToParse: Data) -> ( [String:String], [String:String], [String:String] ) {
        
        // Update UI on the main thread
        // DispatchQueue.main.async(execute: {
        
        
        // Use SwiftyJSON to parse results
        let json = JSON(data: dataToParse)
        let errorObj: JSON = json["error"]
        var faceResults : [String:String] = [:]
        var labelResults : [String:String] = [:]
        var textResults : [String:String] = [:]
        
        
        // Check for error
        if (errorObj.dictionaryValue != [:]) {
            faceResults["text"] = "Error code \(errorObj["code"]): \(errorObj["message"])"
            labelResults["text"] = "Error code \(errorObj["code"]): \(errorObj["message"])"
            textResults["text"] = "Error code \(errorObj["code"]): \(errorObj["message"])"
            
        } else {
            // Parse the response
            // print(json)
            let responses: JSON = json["responses"][0]
            
            // Get face annotations
            let faceAnnotations: JSON = responses["faceAnnotations"]
            
            // if face is detected
            if faceAnnotations != JSON.null {
                let emotions = ["joy", "sorrow", "surprise", "anger"]
                let numPeopleDetected:Int = faceAnnotations.count
                
                faceResults["text"] = "People detected: \(numPeopleDetected)\n\nEmotions detected:\n"
                
                var emotionTotals: [String: Double] = ["sorrow": 0, "joy": 0, "surprise": 0, "anger": 0]
                var emotionLikelihoods: [String: Double] = ["VERY_LIKELY": 5, "LIKELY": 4, "POSSIBLE": 3, "UNLIKELY": 2, "VERY_UNLIKELY": 1]
                
                for index in 0..<numPeopleDetected {
                    let personData:JSON = faceAnnotations[index]
                    
                    // Sum all the detected emotions
                    for emotion in emotions {
                        let lookup = emotion + "Likelihood"
                        let result:String = personData[lookup].stringValue
                        emotionTotals[emotion]! += emotionLikelihoods[result]!
                    }
                }
                // Get emotion likelihood as a % and display in UI
                for (emotion, total) in emotionTotals {
                    let likelihood:Double = total / Double(numPeopleDetected)
                    let rate: Int = Int(likelihood)
                    faceResults["text"]! += "\(emotion): \(rate)"
                }
            } else {
                faceResults["text"] = "No faces found"
            }
            
            // Get label annotations
            let labelAnnotations: JSON = responses["labelAnnotations"]
            let numLabels: Int = labelAnnotations.count
            var labels: Array<String> = []
            
            // N.B. label always exists
            if numLabels > 0 {
                var labelResultsText:String = "Labels found: "
                // for loop
                for index in 0..<numLabels {
                    let label = labelAnnotations[index]["description"].stringValue
                    labels.append(label)
                }
                for label in labels {
                    // if it's not the last item add a comma
                    if labels[labels.count - 1] != label {
                        labelResultsText += "\(label), "
                    } else {
                        labelResultsText += "\(label)"
                    }
                }
                labelResults["text"] = labelResultsText
            } else {
                labelResults["text"] = "No labels found"
            }
            
            // Get text annotations
            let fullTextAnnotation: JSON = responses["fullTextAnnotation"]
            
            // if text is detected
            if fullTextAnnotation != JSON.null {
                textResults["text"] = fullTextAnnotation["text"].stringValue // "poetry..."
            } else {
                textResults["text"] = "No text found"
            }
        }
        // return three dictionaries
        return (faceResults, labelResults, textResults)
        
    }
}
