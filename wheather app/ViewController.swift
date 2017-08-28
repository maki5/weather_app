//
//  ViewController.swift
//  wheather app
//
//  Created by maki on 6/22/17.
//  Copyright © 2017 cm_apps. All rights reserved.
//

import UIKit
import CoreLocation
import FontAwesome_swift


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    var locationManager = CLLocationManager()
    var currentLat = ""
    var currentLong = ""
    var upcoming_weather = Dictionary<String, Any>()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var locationButton: UIBarButtonItem!
    
    @IBAction func resetLocation(_ sender: Any) {
        activityIndicator.startAnimating()
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "current_location")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        activityIndicator.stopAnimating()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.clear
        
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        locationButton.setTitleTextAttributes(attributes, for: .normal)
        locationButton.title = String.fontAwesomeIcon(code: "fa-location-arrow")
        
        let defaults = UserDefaults.standard
        if let currentLocation = defaults.value(forKey: "current_location") as? String {
            if currentLocation == "" {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestLocation()
                label.text = ""
                image.image = UIImage(named: "img/background_2.jpg")
                
            } else {
                let weatherService = WeatherService()
                let current_weather = weatherService.getWeather(location: currentLocation)
                upcoming_weather = weatherService.getDaily(location: currentLocation)
                
                parseResult(result: current_weather)
            }

            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        } else {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            label.text = ""
            image.image = UIImage(named: "img/background_2.jpg")
            
        }
    }

    @IBOutlet var label: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation =  locations.last{

            if currentLat != String(describing: userLocation.coordinate.latitude) || currentLong != String(describing: userLocation.coordinate.longitude) {
                currentLat = String(describing: userLocation.coordinate.latitude)
                currentLong = String(describing: userLocation.coordinate.longitude)
                
                let weatherService = WeatherService()
                
                let result = weatherService.getWeather(latitude: currentLat, longitude: currentLong)
                upcoming_weather = weatherService.getDaily(latitude: currentLat, longitude: currentLong)
                
                parseResult(result: result)
                tableView.reloadData()
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog(error.localizedDescription)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WeatherCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! WeatherCell
//        let cell: WeatherCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell") as! WeatherCell

        cell.backgroundColor = UIColor.clear
        
        let weatherForCell = (upcoming_weather["list"] as? NSArray)?[indexPath.row] as? NSDictionary
        
        guard let date = weatherForCell?["date"] as? String,
            let weather = weatherForCell?["weather"] as? String,
            let temp = weatherForCell?["temp"] as? String
            
            else {
                cell.dateLabel.text = ""
                cell.weatherLabel.text = ""
                cell.tempLabel.text = ""
                return cell
        }
        
        
        let parsedDate = NSDate(timeIntervalSince1970: Double(date)!)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd"
        
        let dateString = dayTimePeriodFormatter.string(from: parsedDate as Date)
        
        let parsedTemp = Int(Double(temp)!)
        
        
        cell.dateLabel.text = dateString
        cell.weatherLabel.text = weather
        cell.tempLabel.text = String(describing: parsedTemp).appending("˚C")

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableCount = ((upcoming_weather["list"] as? NSArray)?.count) {
            return tableCount
        } else {
            return 0
        }
        
    }

    
    
    func parseResult(result :Dictionary<String, String>){
        if !result.isEmpty{
            
            
            guard let temp = result["temp"],
                let description = result["description"],
                var wId = result["wId"],
                let city = result["city"],
                let country = result["country"]
                
                else{
                    self.label.text = "No weather found for your region"
                    return
            }
            
            
            let validTemp = Int(Double(temp)!)
            let resultStr = description + "\n" + String(validTemp) + "°" + "\n" + city + ", " + country
            label.text = resultStr
            
            let index = wId.index(wId.startIndex, offsetBy: 1)
            wId = wId.substring(to: index)
            
            
            var imgId = ""
            
            if Int(wId) == 2 {
                imgId = "200.jpg"
            } else if Int(wId) == 3 {
                imgId = "300.jpg"
            } else if Int(wId) == 5 {
                imgId = "500.jpg"
            } else if Int(wId) == 6 {
                imgId = "600.jpg"
            } else if Int(wId) == 7 {
                imgId = "700.jpg"
            } else if Int(wId) == 8 {
                imgId = "800.jpg"
            } else if Int(wId) == 9 {
                imgId = "900.jpg"
            }
            
            if imgId != "" || imgId == "900.jpg" || imgId == "800" {
                if result["wId"] == "801" {
                    imgId = "801.jpg"
                } else if result["wId"] == "901" {
                    imgId = "901.jpg"
                }
            }
            
            image.image = UIImage(named: "img/\(imgId)")
        }
    
    }


    @IBOutlet var image: UIImageView!

}

