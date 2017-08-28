//
//  WeatherService.swift
//  wheather app
//
//  Created by maki on 6/29/17.
//  Copyright © 2017 cm_apps. All rights reserved.
//

import Foundation


class WeatherService {
    
    func getWeather(latitude: String, longitude: String) -> Dictionary<String, String>{
        let urlStr = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=c6366572bb1205c4818798aa217a0ad7"
        let url = URL(string: urlStr.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
      
        return weatherRequest(url: url!)
    }
    
    
    func getWeather(location: String) -> Dictionary<String, String>{
        
        let urlStr = "http://api.openweathermap.org/data/2.5/weather?q=\(location)&units=metric&appid=c6366572bb1205c4818798aa217a0ad7"
        let url = URL(string: urlStr.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        
        return weatherRequest(url: url!)
    }
    

    func getDaily(latitude: String, longitude: String) -> Dictionary<String, Any>{
        let urlStr = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=7&units=metric&appid=c6366572bb1205c4818798aa217a0ad7"
        let url = URL(string: urlStr.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        
        return dailyWeatherRequest(url: url!)
    }
    
    func getDaily(location: String) -> Dictionary<String, Any>{
        let urlStr = "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(location)&cnt=7&units=metric&appid=c6366572bb1205c4818798aa217a0ad7"
        let url = URL(string: urlStr.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        
        return dailyWeatherRequest(url: url!)
    }
    
    
    private func weatherRequest(url: URL) -> Dictionary<String, String> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Dictionary<String, String> = Dictionary()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                NSLog((error?.localizedDescription)!)
            } else {
                
                if let content = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        guard let description = ((((jsonResult as? NSDictionary)?["weather"] as? NSArray)?[0]) as? NSDictionary)?["description"],
                            let wId = ((((jsonResult as? NSDictionary)?["weather"] as? NSArray)?[0]) as? NSDictionary)?["id"],
                            let temp = ((jsonResult as? NSDictionary)?["main"] as? NSDictionary)?["temp"],
                            let city = (jsonResult as? NSDictionary)?["name"],
                            let country = ((jsonResult as? NSDictionary)?["sys"] as? NSDictionary)?["country"],
                            let windSpd = ((jsonResult as? NSDictionary)?["wind"] as? NSDictionary)?["speed"]
                            else{return}
                        
                        result["description"] = String(describing: description)
                        result["temp"] = String(describing: temp)
                        result["city"] = String(describing: city)
                        result["country"] = String(describing: country)
                        result["windSpd"] = String(describing: windSpd)
                        result["wId"] = String(describing: wId)
                        
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
    
    private func dailyWeatherRequest(url: URL) -> Dictionary<String, Any> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Dictionary<String, Any> = Dictionary<String, Any>()
        var days: Array = Array<Any>()
        var dayHash: Dictionary = Dictionary<String, String>()
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                NSLog((error?.localizedDescription)!)
            } else {
                
                if let content = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        guard let city = ((jsonResult as? NSDictionary)?["city"] as? NSDictionary)?["name"],
                            let country = ((jsonResult as? NSDictionary)?["city"] as? NSDictionary)?["country"]
                            else {return}
                        
                        guard let list = (jsonResult as? NSDictionary)?["list"] as? NSArray
                            else {return}
                        
                        for day in list {
                            guard let date = (day as? NSDictionary)?["dt"],
                                let temp = (((day as? NSDictionary)?["temp"]) as? NSDictionary)?["day"],
                                let weather = (((day as? NSDictionary)?["weather"] as? NSArray)?[0] as? NSDictionary)?["main"]
                                else { continue }
                            
                            dayHash["date"] = String(describing: date)
                            dayHash["temp"] = String(describing: temp)
                            dayHash["weather"] = String(describing: weather)
                            
                            days.append(dayHash)
                        }
                        
                        result["city"] = city
                        result["country"] = country
                        result["list"] = days
                        
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
