//
//  ViewController.swift
//  AdvertisingSlider
//
//  Created by Виталий Сероштанов on 28.10.2019.
//  Copyright © 2019 Виталий Сероштанов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slider: AdvertisingSlider!
    
    // Text source: https://en.wikipedia.org/wiki/Travel
    
    fileprivate let titles = ["The origin of the word \"travel\" is most likely lost to history.",
    "The term \"travel\" may originate from the Old French word travail, which means 'work'",
    "According to the Merriam Webster dictionary, the first known use of the word travel was in the 14th century.",
    "It also states that the word comes from Middle English travailen, travelen (which means to torment, labor, strive, journey) and earlier from Old French travailler (which means to work strenuously, toil)",
    "In English we still occasionally use the words \"travail\", which means struggle.",
    "There's a big difference between simply being a tourist and being a true world traveler"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slider.dataSource = self
        self.slider.overViewColor = UIColor.black
        self.slider.overViewAlpha = 0.2
        self.slider.cornerRadius = 8
        self.slider.pageControlInteraction = true
        self.slider.font = UIFont.boldSystemFont(ofSize: 16)
        self.slider.textRows = 5
        self.slider.contentMode = .scaleAspectFill
        self.slider.moveToPage(3, animated: false)
    }
}

extension ViewController : AdvertisingSliderDataSource {
    func pagesCount(forSlider: AdvertisingSlider) -> Int {
        return self.titles.count
    }
    
    func imageForIndex(_ index: Int, slider: AdvertisingSlider) -> UIImage {
        return UIImage.init(named: "\(index).jpg")!
    }
    
    func textForIndex(_ index: Int, slider: AdvertisingSlider) -> String {
        return self.titles[index]
    }
}
