//
//  PageViewController.swift
//  MobileVisionary
//
//  Created by Bowen Sun on 8/8/18.
//  Copyright © 2018 Jinnie Park. All rights reserved.
//

import Foundation
import UIKit


protocol PageVCDelegate {
    func pageVCDidChange(scanType: ScanType)
    func pageVCDidRequestRescan()
    func requestToSendEmail(data: String)
}

enum ScanType{
    case face
    case text
}

class PageVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!// = UIScrollView(frame: CGRect(x:0, y:0, width:320,height: 300))
    @IBOutlet weak var pageControl : UIPageControl!// = UIPageControl(frame: CGRect(x:50,y: 300, width:200, height:50))
    @IBOutlet weak var textView: TextResultView!
    @IBOutlet weak var faceView: FaceResultView!
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var delegate: PageVCDelegate?
    var textToShare: String? = "string that you want to copy"
    var data: ([String : String], [String : Any], [String : String])?{
        didSet{
            textView.data = self.data
            faceView.data = self.data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageControl()
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        self.view.addSubview(scrollView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        frame.origin.x = 10
        let width = self.scrollView.frame.width - 20
        frame.size.width = width
        frame.size.height = 43
        textView.frame = frame
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        
        frame.origin.x = self.scrollView.frame.size.width + 10
        faceView.frame = frame
        faceView.layer.cornerRadius = 10
        faceView.layer.masksToBounds = true
        
        scrollView.addSubview(textView)
        scrollView.addSubview(faceView)
        
        
        
        //frame.origin.x = self.scrollView.frame.size.width + 10
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 2,height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        
        delegate?.pageVCDidChange(scanType: .text)
    }
    
    private func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = 2
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc private func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        pageControl.currentPage = pageNumber
        let type = pageNumber == 0 ? ScanType.text : ScanType.face
        delegate?.pageVCDidChange(scanType: type)
    }
    
    func extendPage(toHigh: Bool){
        let height: CGFloat = toHigh ? 463 : 43
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.textView.frame.size.height = height
                self.faceView.frame.size.height = height
            }
        }
    }
    
    @IBAction func reScanButtonClicked(){
        delegate?.pageVCDidRequestRescan()
    }
    
    @IBAction func copyButtonClicked(_ sender: Any) {
        UIPasteboard.general.string = self.data?.2["text"]
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        if let data = self.data{
            if let text = data.2["text"]{
                delegate?.requestToSendEmail(data: text)
            }
        }
        
    }
    
}
