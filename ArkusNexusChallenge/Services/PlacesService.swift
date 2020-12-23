//
//  PlacesService.swift
//  ArkusNexusChallenge
//
//  Created by Miguel Aquino on 22/12/20.
//

import UIKit

class PlacesService {
    
    //MARK: - Properties
    static let shared  = PlacesService()
    let cache = NSCache<NSString, UIImage>()
    
    //MARK:- Services Implementation
    func getPlaces(completion: @escaping (Result<[Place], APIError> ) -> Void) {
        guard let url = URL(string: ApiURL.placesURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: {( data, response ,error) in
            if let _ = error {
                completion(.failure(.unknownError))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do{
                let placesResponse = try JSONDecoder().decode([Place].self, from: data)
                completion(.success(placesResponse))
            } catch {
                completion(.failure(.invalidData))
            }
        }).resume()
    }
    
    func getImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            
            completion(image)
        }

        task.resume()
        
        

//        if let cachedImage = cache.object(forKey: urlString as NSString) {
//            completion(cachedImage)
//        } else {
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if error != nil {
//                    completion(nil)
//
//                } else if let data = data, let image = UIImage(data: data) {
//                    self.cache.setObject(image, forKey: url.absoluteString as NSString)
//                    completion(image)
//                } else {
//                    completion(nil)
//                }
//            }
//        }
    }
}
