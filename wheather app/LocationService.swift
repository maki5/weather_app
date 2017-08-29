//
//  LocationService.swift
//  wheather app
//
//  Created by maki on 6/29/17.
//  Copyright © 2017 cm_apps. All rights reserved.
//

import Foundation

class LocationService {
    
    func getLocation(name :String) -> [String]{
        var result = [String]()
        let semaphore = DispatchSemaphore(value: 0)
        
        
        let urlStr = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(name)&types=(regions)&key=AIzaSyCnEcJiep5cPfD1UGrojLyqB9TUO3SrjrA"
        
        let url = URL(string: urlStr.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                NSLog((error?.localizedDescription)!)
            } else {
                
                if let content = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        guard let locNames = (jsonResult as? NSDictionary)?["predictions"] as? NSArray
                        else{return}
                        
                        for location in locNames{
                            if let locationName = ((location as? NSDictionary)?["description"] as? String) {
                                result.append(locationName)
                            }
                            
                        }
                        
                        
                        semaphore.signal()
                        
                    } catch {
                        NSLog(error.localizedDescription)
                    }
                    
                }
            }
        }
        
        task.resume()
        semaphore.wait(timeout: .distantFuture)
        
        
        return result
    }
}
