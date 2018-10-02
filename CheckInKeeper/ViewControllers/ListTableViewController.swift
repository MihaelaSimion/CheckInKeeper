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
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.refreshControl = refresh
        
        getCheckinData()
        NotificationCenter.default.addObserver(self, selector: #selector(getCheckinData), name: .taggedPlaceResponseChanged, object: nil)
    }
    
    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for check-ins"
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
        guard let taggedPlaces = taggedPlaces else { return 1 }
        return taggedPlaces.count > 0 ? taggedPlaces.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let taggedPlaces = taggedPlaces, taggedPlaces.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainReuseCell", for: indexPath) as? MainTableViewCell
            cell?.configureCell(taggedPlaces[indexPath.row], for: indexPath)
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nothingFoundCell", for: indexPath) as? NothingFoundTableViewCell
            cell?.configureNothingFoundCell()
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        }
    }
    
    //MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taggedPlaces = taggedPlaces, taggedPlaces.count > 0 else { return }
        performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailsTableViewController {
            guard let taggedPlaces = taggedPlaces else { return }
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            controller.taggedPlace = taggedPlaces[index]
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .taggedPlaceResponseChanged, object: nil)
    }
}

//MARK: Search Bar Delegate:
extension ListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let firstThreeLettersPlaceNameArray = taggedPlaces?.filter({ (tagedPlace) -> Bool in
            guard let searchBarText = searchBar.text else { return false }
            return tagedPlace.place.name.lowercased().hasPrefix(searchBarText.lowercased())
        })
        taggedPlaces = firstThreeLettersPlaceNameArray
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
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
