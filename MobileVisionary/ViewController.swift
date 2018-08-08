//
//  ViewController.swift
//  MobileVisionary
//
//  Created by Jinnie Park on 8/6/18.
//  Copyright © 2018 Jinnie Park. All rights reserved.
//

import UIKit
import ARKit
import Vision
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var sceneKitView: ARSCNView!
    //Let's hack.
    var scanType: ScanType = .text
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    var scannedFaceViews = [UIView]()
    var scanTimer: Timer?
    let googleVisionManager = GoogleVisionManager()
    var pageVC: PageVC!
    
    private var imageOrientation: CGImagePropertyOrientation {
        switch UIDevice.current.orientation {
        case .portrait: return .right
        case .landscapeRight: return .down
        case .portraitUpsideDown: return .left
        case .unknown: fallthrough
        case .faceUp: fallthrough
        case .faceDown: fallthrough
        case .landscapeLeft: return .up
        }
    }
    
    @IBAction func changeFrame(){
        self.heightLayout.constant = 500
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
            self.pageVC.extendPage(toHigh: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.googleVisionManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let config = ARWorldTrackingConfiguration()
        sceneKitView.session.run(config, options: .resetTracking)
        startTimer()
    }
    
    func startTimer(){
        scanTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.scan), userInfo: nil, repeats: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pagecontrol"{
            self.pageVC = segue.destination as! PageVC
            self.pageVC.delegate = self
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dropAnchor() {
        let image = UIImage(named: "anchor")
        // Measurements in meters
        // One-sided plane that shows the image
        let plane = SCNPlane(width: 0.4, height: 0.4)
        plane.firstMaterial!.diffuse.contents = image
        let scene = SCNScene()
        for i in -20..<20 {
            // Coordinate space in view that will hold the plane
            let node = SCNNode()
            node.geometry = plane
            // 1.5 meter away from user
            node.position = SCNVector3(Double(i), 0, -1.0)
            scene.rootNode.addChildNode(node)
        }
        // Set the scene to sceneKitView
        sceneKitView.scene = scene
        
    }
    
    @objc
    private func scan() {
        if self.scanType == .face{
            scanForFaces()
        } else {
            scanForText()
        }
    }
    
    @objc
    private func scanForFaces() {
        
        //remove the test views and empty the array that was keeping a reference to them
        _ = scannedFaceViews.map { $0.removeFromSuperview() }
        scannedFaceViews.removeAll()
        
        guard let capturedImage = sceneKitView.session.currentFrame?.capturedImage else { return }
        
        let image = CIImage.init(cvPixelBuffer: capturedImage)
        
        let detectFaceRequest = VNDetectFaceRectanglesRequest { (request, error) in
            
            DispatchQueue.main.async {
                //Loop through the resulting faces and add a red UIView on top of them.
                if let faces = request.results as? [VNFaceObservation] {
                    if faces.count > 0 {
                        self.googleVisionManager.uploadImage(image: image, scantype: self.scanType)
                        for face in faces {
                            let faceView = UIView(frame: self.faceFrame(from: face.boundingBox))
                            faceView.backgroundColor = .red
                            
                            self.sceneKitView.addSubview(faceView)
                            
                            self.scannedFaceViews.append(faceView)
                        }
                    }
                }
            }
        }
        print ("Arrived line 133")
        DispatchQueue.global().async {
            print ("line 135")
            try? VNImageRequestHandler(ciImage: image, orientation: self.imageOrientation).perform([detectFaceRequest])
            print ("line 137")
        }
    }
    
    @objc
    private func scanForText() {
        //remove the test views and empty the array that was keeping a reference to them
        _ = scannedFaceViews.map { $0.removeFromSuperview() }
        scannedFaceViews.removeAll()
        
        guard let capturedImage = sceneKitView.session.currentFrame?.capturedImage else { return }
        let image = CIImage.init(cvPixelBuffer: capturedImage)
        self.googleVisionManager.uploadImage(image: image, scantype: self.scanType)
        
    }
    
    private func faceFrame(from boundingBox: CGRect) -> CGRect {
        
        //translate camera frame to frame inside the ARSKView
        let origin = CGPoint(x: boundingBox.minX * sceneKitView.bounds.width, y: (1 - boundingBox.maxY) * sceneKitView.bounds.height)
        let size = CGSize(width: boundingBox.width * sceneKitView.bounds.width, height: boundingBox.height * sceneKitView.bounds.height)
        
        return CGRect(origin: origin, size: size)
    }
    
    
}

extension ViewController: PageVCDelegate{
    func pageVCDidRequestRescan() {
        self.heightLayout.constant = 80
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        pageVC.extendPage(toHigh: false)
        startTimer()
    }
    
    func pageVCDidChange(scanType: ScanType) {
        self.scanType = scanType
    }
}

extension ViewController: GoogleVisionManagerDelegate{
    func managerDidReceiveValidData(manager: GoogleVisionManager, data: ([String : String], [String : Any], [String : String])) {
        changeFrame() // if data successfully called, will automatically expand
        scanTimer?.invalidate()
    }
    
    
}
