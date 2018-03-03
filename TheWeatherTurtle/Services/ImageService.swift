//
//  ImageService.swift
//  TheWeatherTurtle
//
//  Created by Mario Eguiluz on 15/02/2018.
//  Copyright © 2018 Red Turtle Technologies. All rights reserved.
//

import Foundation
import UIKit

protocol ImageService {
    func setImage(from url: URL?, completion: @escaping (UIImage?) -> Void)
    func clearCache()
}

final class ImageDownloader: ImageService {
    
    static let shared = ImageDownloader()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 50
        cache.totalCostLimit = 30*1024*1024
    }
    
    func setImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        
        if let image = cache.object(forKey: NSString(string: url.absoluteString)) {
            completion(image)
            
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let data = data, let image = UIImage(data: data), error == nil else {
                    completion(nil)
                    return
                }
                
                self?.cache.setObject(image, forKey: NSString(string: url.absoluteString))
                DispatchQueue.main.async {
                    completion(image)
                }
                
            }.resume()
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
