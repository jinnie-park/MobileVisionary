//
//  JsonParser.swift
//
//
//  Created by Ashley Koo on 8/7/18.
//

import Foundation
import SwiftyJSON


class JSONParser : NSObject {
    
    func analyzeResults(_ dataToParse: Data) -> [String : String] {
        
        // Update UI on the main thread
        // DispatchQueue.main.async(execute: {
        
        
        // Use SwiftyJSON to parse results
        let json = JSON(data: dataToParse)
        let errorObj: JSON = json["error"]
        
        //        self.spinner.stopAnimating()
        //        self.imageView.isHidden = true
        //        self.labelResults.isHidden = false
        //        self.faceResults.isHidden = false
        //        self.faceResults.text = ""
        
        // Check for errors
        if (errorObj.dictionaryValue != [:]) {
            //            self.labelResults.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
        } else {
            // Parse the response
            // print(json)
            let responses: JSON = json["responses"][0]
            
            var faceResults : [String:String] = [:]
            
            // Get face annotations
            let faceAnnotations: JSON = responses["faceAnnotations"]
            if faceAnnotations != JSON.null {
                let emotions: Array<String> = ["joy", "sorrow", "surprise", "anger"]
                
                let numPeopleDetected:Int = faceAnnotations.count
                
                faceResults["text"] = "People detected: \(numPeopleDetected)\n\nEmotions detected:\n"
                
                var emotionTotals: [String: Double] = ["sorrow": 0, "joy": 0, "surprise": 0, "anger": 0]
                var emotionLikelihoods: [String: Double] = ["VERY_LIKELY": 0.9, "LIKELY": 0.75, "POSSIBLE": 0.5, "UNLIKELY":0.25, "VERY_UNLIKELY": 0.0]
                
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
                    let percent: Int = Int(round(likelihood * 100))
                    faceResults["text"]! += "\(emotion): \(percent)%\n"
                }
            } else {
                faceResults["text"] = "No faces found"
            }
            return (faceResults)
            //                // Get label annotations
            //                let labelAnnotations: JSON = responses["labelAnnotations"]
            //                let numLabels: Int = labelAnnotations.count
            //                var labels: Array<String> = []
            //                if numLabels > 0 {
            //                    var labelResultsText:String = "Labels found: "
            //                    for index in 0..<numLabels {
            //                        let label = labelAnnotations[index]["description"].stringValue
            //                        labels.append(label)
            //                    }
            //                    for label in labels {
            //                        // if it's not the last item add a comma
            //                        if labels[labels.count - 1] != label {
            //                            labelResultsText += "\(label), "
            //                        } else {
            //                            labelResultsText += "\(label)"
            //                        }
            //                    }
            //                    self.labelResults.text = labelResultsText
            //                } else {
            //                    self.labelResults.text = "No labels found"
            //                }
        }
        
        
    }
}
