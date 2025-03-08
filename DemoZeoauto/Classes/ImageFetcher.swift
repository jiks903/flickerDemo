//
//  ImageFetcher.swift
//  DemoZeoauto
//
//  Created by Jeegnesh Solanki on 08/03/25.
//

import UIKit

class ImageFetcher {
    private let cache = NSCache<NSString, UIImage>()
    private let apiKey = "3f7046fe0897516df587cc3e6226f878"
    private var currentPage = 1
    private var isLoading = false
    
    func fetchImages(page: Int, completion: @escaping ([FlickrImage]?) -> Void) {
        guard !isLoading else { return }
        // Prevent multiple calls
        isLoading = true
        
        let urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(apiKey)&format=json&nojsoncallback=1&per_page=100&page=\(page)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            defer { self.isLoading = false } // Reset loading flag
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(FlickrResponse.self, from: data)
                DispatchQueue.main.async { completion(response.photos.photo) }
            } catch {
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, let image = UIImage(data: data), error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            // Limit cache size to prevent memory leak issues
            if cache.totalCostLimit == 0 {
                cache.totalCostLimit = 50 * 1024 * 1024 // 50MB limit
            }
            
            self.cache.setObject(image, forKey: url.absoluteString as NSString, cost: data.count)
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
}
