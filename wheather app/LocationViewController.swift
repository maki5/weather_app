//
//  LocationViewController.swift
//  wheather app
//
//  Created by maki on 6/29/17.
//  Copyright © 2017 cm_apps. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class LocationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate  {
    
    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let locationService = LocationService()
    
  
    
    var filteredCities = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if (defaults.value(forKey: "current_location") != nil) {
            currentLocationLabel.text?.append((defaults.value(forKey: "current_location") as? String)!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = filteredCities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        let currentLocation = filteredCities[indexPath.row]
        if currentLocation != "" {
            defaults.set(currentLocation, forKey: "current_location")
            
        }
        
        
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "cellSegue", sender: cell)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! != "" {
            filteredCities = []
            filteredCities = locationService.getLocation(name: searchController.searchBar.text!)
        }
        self.tableView.reloadData()
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
    }
    
    
}
