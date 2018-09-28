//
//  ListTableViewController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/27/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    var taggedPlaces: [TaggedPlace]?
    let myColor = UIColor(red: 19, green: 142, blue: 226, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        
        // view.backgroundColor = myColor
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.refreshControl = refresh
        
        getCheckinData()
        NotificationCenter.default.addObserver(self, selector: #selector(getCheckinData), name: .taggedPlaceResponseChanged, object: nil)
    }
    
    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for your check-ins"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
    
    @objc func getCheckinData() {
        if let tabController = tabBarController as? MyTabBarController {
            if let data = tabController.taggedPlaceResponse?.data {
                let sortedData = data.sorted { (first, next) -> Bool in
                    return first.created_time! > next.created_time!
                }
                taggedPlaces = sortedData
            }
        }
        tableView.reloadData()
    }
    
    @objc func refreshAction() {
        if let tabBar = tabBarController as? MyTabBarController {
            tabBar.getUserDetails()
        }
        tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard taggedPlaces != nil else { return 0 }
        return taggedPlaces!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        if let taggedPlaces = taggedPlaces {
            cell.textLabel?.text = taggedPlaces[indexPath.row].place.name
            cell.detailTextLabel?.text = taggedPlaces[indexPath.row].created_time?.toCustomPrint()
            return cell
        } else {
            return cell
        }
    }
    
    //MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard taggedPlaces != nil else { return }
        performSegue(withIdentifier: "detailsSegue", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailsTableViewController {
            guard let taggedPlaces = taggedPlaces else { return }
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            controller.taggedPlace = taggedPlaces[index]
        }
    }
}

//MARK: Search Bar Delegate:
extension ListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let firstThreeLettersPlaceNameArray = taggedPlaces?.filter({ (tagedPlace) -> Bool in
            return tagedPlace.place.name == searchBar.text || tagedPlace.place.name.prefix(3) == searchBar.text?.prefix(3) ||
                tagedPlace.place.name.prefix(2) == searchBar.text?.prefix(2) || tagedPlace.place.name.prefix(1) == searchBar.text?.prefix(1)
        })
        taggedPlaces = firstThreeLettersPlaceNameArray
        // view.backgroundColor = .white
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // view.backgroundColor = myColor
        searchBar.resignFirstResponder()
        searchBar.text = nil
        getCheckinData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == true {
            getCheckinData()
        }
    }
}
