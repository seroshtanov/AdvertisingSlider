//
//  AdvSliderImageView.swift
//  AdvertisingSlider
//
//  Created by Виталий Сероштанов on 30.01.2020.
//  Copyright © 2020 Виталий Сероштанов. All rights reserved.
//

import UIKit

class AdvSliderImageView: UIImageView {
    let imageCache = NSCache<AnyObject, AnyObject>()
    fileprivate var downloading = false

    func downloadImage(urlString: String) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        if downloading {
            print("Image \(urlString) has already been downloading")
            return
        }
        downloading = true
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {[weak self] (data, response, error) in
            self?.downloading = false
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async  {
                if let downloadedImage = UIImage(data: data!) {
                    self?.imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self?.image = downloadedImage
                }
            }
            
        }).resume()
    }

}
