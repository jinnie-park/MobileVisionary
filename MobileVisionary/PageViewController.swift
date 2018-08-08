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
}

enum ScanType{
    case face
    case text
}

class PageVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!// = UIScrollView(frame: CGRect(x:0, y:0, width:320,height: 300))
    @IBOutlet weak var pageControl : UIPageControl!// = UIPageControl(frame: CGRect(x:50,y: 300, width:200, height:50))
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var faceView: UIView!
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var delegate: PageVCDelegate?
    
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
        frame.size.height = 500 - 37//self.scrollView.frame.height
        textView.frame = frame
        
        frame.origin.x = self.scrollView.frame.size.width + 10
        faceView.frame = frame
        scrollView.addSubview(textView)
        scrollView.addSubview(faceView)
        
        //frame.origin.x = self.scrollView.frame.size.width + 10
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 2,height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        
        delegate?.pageVCDidChange(scanType: .text)
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = 2
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        pageControl.currentPage = pageNumber
        let type = pageNumber == 0 ? ScanType.text : ScanType.face
        delegate?.pageVCDidChange(scanType: type)
    }
    
}