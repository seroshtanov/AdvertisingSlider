//
//  AdvertisingSlider.swift
//  Education
//
//  Created by Виталий Сероштанов on 26.10.2019.
//  Copyright © 2019 Виталий Сероштанов. All rights reserved.
//

import UIKit

public protocol AdvertisingSliderDataSource {
    func pagesCount(forSlider: AdvertisingSlider) -> Int
    func imageForIndex(_ index: Int, slider: AdvertisingSlider) -> UIImage
    func textForIndex(_ index: Int, slider: AdvertisingSlider) -> String
}


@IBDesignable public class AdvertisingSlider: UIView {

    public var dataSource : AdvertisingSliderDataSource?
    fileprivate var activePageNumber = 0 {
        didSet {
            self.updateButtonsState()
            self.updateLabel()
        }
    }

    
    @IBInspectable public var overViewColor : UIColor! = UIColor.clear
    @IBInspectable public var overViewAlpha : CGFloat = 1
    @IBInspectable public var activePageColor: UIColor = UIColor.init(red: 83/255.0, green: 164/255.0, blue: 248/255.0, alpha: 1)
    @IBInspectable public var pageColor : UIColor = UIColor.init(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1)
    @IBInspectable public var imageViewColor : UIColor = UIColor.init(red: 83/255.0, green: 164/255.0, blue: 248/255.0, alpha: 1)
    @IBInspectable public var pagerHeight : CGFloat = 35
    @IBInspectable public var cornerRadius : CGFloat = 8
    @IBInspectable public var scrollingManually : Bool = false
    @IBInspectable public var pageControlInteraction : Bool = false
    @IBInspectable public var textColor : UIColor = UIColor.white
    @IBInspectable public var font : UIFont = UIFont.boldSystemFont(ofSize: 14)
    @IBInspectable public var textRows : Int = 3
    @IBInspectable public var buttonWidth : CGFloat = 35
    @IBInspectable public var defaultText : String?
    
    @IBInspectable public var pageControlOverImages : Bool = false
    
    @IBInspectable public var leftButtonImage : UIImage?
    @IBInspectable public var rightButtonImage : UIImage?
    
    fileprivate var topView : UIView!
    fileprivate var scrollView : UIScrollView!
    fileprivate var pageControl : UIPageControl!
    fileprivate var leftButton : UIButton!
    fileprivate var rightButton : UIButton!
    fileprivate var textLabel : UILabel?
    
    

    

    override public func draw(_ rect: CGRect) {
        if rect.size.width < 100 || rect.size.height < 100 {
            return
        }
        
        
        self.drawScrollViewIfNeeded(rect: rect)
        self.drawTopViewIfNeeded(rect: rect)
        self.drawPageControlIfNeeeded(rect: rect)
        
        self.updateButtonsState()
        self.updateLabel()
    }
    
    public func reloadData()  {
        self.fillScrollView()
    }
    
    public func nextPage() -> Bool {
        if self.activePageNumber >= (self.pagesCount() - 1) {return false}
        self.pageControl?.currentPage += 1
        self.scrollToCurrentPage()
        return true
    }
    public func previousPage() -> Bool {
        if self.activePageNumber == 0 {return false}
        self.pageControl?.currentPage -= 1
        self.scrollToCurrentPage()
        return true
    }
    
    public func moveToPage(_ index: Int, animated: Bool) {
        guard (index >= 0 && index <= (self.pagesCount() - 1)) || index == 0 else {
            fatalError("Index out of bounds")
        }
        
        if self.scrollView != nil, self.pageControl != nil {
            self.pageControl?.currentPage = index
            self.scrollToCurrentPage(animated: animated)
        } else {
            self.activePageNumber = index
        }
    }
    
    fileprivate func getImage(name: String) -> UIImage? {
        let bundle = Bundle.init(for: AdvertisingSlider.self)
        let result = UIImage.init(named: name, in: bundle, compatibleWith: nil)
        return result
    }
    
}

// MARK : PageControl
extension AdvertisingSlider {
    fileprivate func drawPageControlIfNeeeded(rect: CGRect) {
        let frame = self.calculatePageControlFrame(rect: rect)
        if self.pageControl != nil {
            self.pageControl.frame = frame
        } else
        {
            self.pageControl = UIPageControl.init(frame: frame)
            self.pageControl.addTarget(self, action:#selector(updatePage(sender:)), for: .touchUpInside)
            self.addSubview(pageControl)
        }
        self.pageControl.pageIndicatorTintColor  = self.pageColor
        self.pageControl.currentPageIndicatorTintColor = self.activePageColor
        self.pageControl.numberOfPages = self.pagesCount()
        self.pageControl.currentPage = self.activePageNumber
        self.pageControl.isUserInteractionEnabled = self.pageControlInteraction
    }
    
    fileprivate func calculatePageControlFrame(rect: CGRect) -> CGRect {
        let width = rect.size.width
        let height = self.pagerHeight
        let originX = CGFloat(0)
        let originY = rect.size.height - height
        return CGRect.init(x: originX, y: originY, width: width, height: height)
    }
    
    @objc fileprivate  func updatePage(sender: Any?) {
        self.scrollToCurrentPage()
    }
}

//MARK: ScrollView

extension AdvertisingSlider {
    fileprivate func drawScrollViewIfNeeded(rect: CGRect) {
        let frame = self.calculateTopViewFrame(rect: rect)
        if self.scrollView == nil {
            self.scrollView = UIScrollView.init(frame: frame)
            self.scrollView.clipsToBounds = true
            self.scrollView.isPagingEnabled = true
            self.scrollView.delegate = self
            self.addSubview(scrollView)
        } else {
            self.scrollView.frame = frame
        }
        self.scrollView.layer.cornerRadius = self.cornerRadius
        self.scrollView.backgroundColor = self.imageViewColor
        self.scrollView.isUserInteractionEnabled = self.scrollingManually
        self.fillScrollView()
    }
    
    fileprivate func fillScrollView() {
        guard self.scrollView != nil  else {return}

        self.scrollView.subviews.forEach { $0.removeFromSuperview()}
        for index in 0 ..<  self.pagesCount() {
            let ivFrame = CGRect.init(x: CGFloat(index) * self.scrollView.frame.size.width, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
            let imageView = UIImageView.init(frame: ivFrame)
            imageView.image = self.imageForIndex(index)
            imageView.contentMode = self.contentMode
            scrollView.addSubview(imageView)

        }
        scrollView.contentSize = CGSize.init(width: CGFloat(self.pagesCount()) * self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
        self.scrollToCurrentPage()
    }
    
    fileprivate func calculateTopViewFrame(rect: CGRect) -> CGRect {
        let width = rect.size.width
        let height = self.pageControlOverImages ? rect.size.height : rect.size.height - pagerHeight
        let originX = CGFloat(0)
        let originY = CGFloat(0)
        return CGRect.init(x: originX, y: originY, width: width, height: height)
    }
}


extension AdvertisingSlider {
    fileprivate func drawTopViewIfNeeded(rect: CGRect) {
        guard !self.scrollingManually  else {
            self.topView?.removeFromSuperview()
            self.leftButton?.removeFromSuperview()
            self.rightButton?.removeFromSuperview()
            self.textLabel?.removeFromSuperview()
            return
        }
        
        let frame = self.calculateTopViewFrame(rect: rect)
        let leftButtonFrame = CGRect.init(x: 0, y: 0, width: self.buttonWidth, height: frame.size.height)
        let rightButtonFrame = CGRect.init(x: frame.size.width - self.buttonWidth, y: 0, width: self.buttonWidth, height: frame.size.height)
        let labelFrame  = CGRect.init(x: self.buttonWidth, y: 6, width: frame.size.width - (self.buttonWidth * 2), height: frame.size.height - 12)
        
        if self.topView == nil {
            self.topView = UIView.init(frame: frame)
            self.addSubview(topView)

        } else {
            self.topView.frame = frame
        }
        
        if self.leftButton == nil {
            self.leftButton = UIButton.init(frame: leftButtonFrame)
            self.leftButton.addTarget(self, action:#selector(leftButtonPressed(sender:)), for: .touchUpInside)
            self.addSubview(self.leftButton)
        } else {
            self.leftButton.frame = leftButtonFrame
        }
        
        if self.rightButton == nil {
            self.rightButton = UIButton.init(frame: rightButtonFrame)
            self.rightButton.addTarget(self, action: #selector(rightButtonPressed(sender:)), for: .touchUpInside)
            self.addSubview(self.rightButton)
        } else {
            self.rightButton.frame = rightButtonFrame
        }
        
        if self.textLabel == nil {
            self.textLabel = UILabel.init(frame: labelFrame)
            self.textLabel?.textAlignment = .center
            self.addSubview(textLabel!)
        } else {
            self.textLabel?.frame = labelFrame
        }
        
        self.textLabel?.textColor =  self.textColor
        self.textLabel?.font = self.font
        self.textLabel?.numberOfLines = self.textRows
        
        
        self.topView.backgroundColor = self.overViewColor
        self.topView.alpha = self.overViewAlpha
        self.topView.layer.cornerRadius = self.cornerRadius
        
        if self.leftButtonImage == nil {
            self.leftButton.setImage(self.getImage(name: "advSliderLeft"), for: .normal)
        } else {
            self.leftButton.setImage(self.leftButtonImage, for: .normal)
        }
        
        if self.rightButtonImage == nil {
            self.rightButton.setImage(self.getImage(name: "advSliderRight"), for: .normal)
        } else {
            self.rightButton.setImage(self.rightButtonImage, for: .normal)
        }
    }
    
    fileprivate func updateButtonsState() {
        let isFirstPage  = (self.activePageNumber == 0)
        let isLastPage = (self.activePageNumber >= (self.pagesCount() - 1))
        self.leftButton?.alpha =  isFirstPage ? 0.5 : 1
        self.leftButton?.isEnabled = !isFirstPage
        self.rightButton?.alpha =  isLastPage ? 0.5 : 1
        self.rightButton?.isEnabled = !isLastPage
    }
    
    fileprivate func updateLabel() {
        if self.pagesCount() > 0 {
           self.textLabel?.text = self.textForIndex(self.activePageNumber)
        } else {
            self.textLabel?.text = self.defaultText
        }
        
    }
    
}

extension AdvertisingSlider  {
    @objc fileprivate func leftButtonPressed(sender: UIButton?){
        _ = self.previousPage()
    }
    @objc fileprivate func rightButtonPressed(sender: UIButton?){
        _ = self.nextPage()
    }
    
    fileprivate func scrollToCurrentPage(animated: Bool = true) {
        self.scrollView?.scrollRectToVisible(CGRect.init(x: self.scrollView.frame.size.width * CGFloat(pageControl?.currentPage ?? 0), y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height), animated: animated)
    }
}


extension AdvertisingSlider : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let previousCurrentPage = activePageNumber
        let visibleBounds = scrollView.bounds
        activePageNumber = min(max(Int(floor(visibleBounds.midX / visibleBounds.width)), 0), self.pagesCount() - 1)
        if activePageNumber != previousCurrentPage {
            self.pageControl.currentPage = activePageNumber
        }
    }
}


//MARK: Data

extension AdvertisingSlider {
    fileprivate func pagesCount() -> Int {
        if self.dataSource != nil {
            return self.dataSource!.pagesCount(forSlider: self)
        } else {
            return 0
        }
    }
    fileprivate func imageForIndex(_ index: Int) -> UIImage {
        return self.dataSource!.imageForIndex(index, slider: self)
    }
    fileprivate func textForIndex(_ index: Int) -> String {
        return self.dataSource!.textForIndex(index, slider: self)
    }
}


