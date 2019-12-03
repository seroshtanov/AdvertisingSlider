//
//  UIImageView+WebCache.swift
//  AdvertisingSlider
//
//  Created by Виталий Сероштанов on 03.12.2019.
//  Copyright © 2019 Виталий Сероштанов. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
fileprivate var downloading = false

extension UIImageView {

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
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            downloading = false
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async  {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
            
        }).resume()
    }

}
