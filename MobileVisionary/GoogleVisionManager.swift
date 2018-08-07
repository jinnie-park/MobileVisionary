//
//  GoogleVisionManager.swift
//  MobileVisionary
//
//  Created by Jinnie Park on 8/7/18.
//  Copyright © 2018 Jinnie Park. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol GoogleVisionManagerDelegate {
    func textResponseDidComeBack(text: String)
}

class GoogleVisionManager: NSObject {
    
    var googleAPIKey = "AIzaSyBdsJ0TRoeU36GFFz0Db366rquu_-kRa0s"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    var session = URLSession.shared
    var delegate: GoogleVisionManagerDelegate?
    
    override init(){
    }
    
    private func CIImageToBase64(_ image: CIImage) -> String {
        let uiImage = UIImage.init(ciImage: image)
        return base64EncodeImage(uiImage)
    }
    
    private func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        let oldSize: CGSize = image.size
        let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
        imagedata = resizeImage(newSize, image: image)
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    private func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func uploadImage(image: CIImage) {
        let base64 = CIImageToBase64(image)
//        createRequest(base64)
        createTextRequest(base64)
        
    }
    
    private func createTextRequest(_ imageBase64: String) {
        var request = URLRequest(url: googleURL)
        request.httpMethod  = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    
    private func createRequest(_ imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ],
                    [
                        "type": "FACE_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    private func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }

            let json = JSON(data: data)
            let responses: JSON = json["responses"][0]
            let textAnnotations: JSON = responses["textAnnotations"]
            if textAnnotations != JSON.null {
                self.delegate?.textResponseDidComeBack(text: "random string")
            }
            
            //call the parser
        }
        
        task.resume()
    }
}
