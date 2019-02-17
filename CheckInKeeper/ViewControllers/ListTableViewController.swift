//
//  ListTableViewController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/27/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    var taggedPlaces: [TaggedPlace]? {
        didSet {
            tableView.reloadData()
        }
    }

    var immutableInitialListOfTaggedPlaces: [TaggedPlace]?

    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        tableView.backgroundColor = Constants.Colors.backgroundColor

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.refreshControl = refresh
        tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
    }

    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for check-ins"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }

    @objc
    func refreshAction() {
        if let tabBarController = tabBarController as? MyTabBarController {
            tabBarController.refreshActionFromListView()
        }
        tableView.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let taggedPlaces = taggedPlaces else { return 1 }
        return taggedPlaces.isEmpty ? 1 : taggedPlaces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let taggedPlaces = taggedPlaces, !taggedPlaces.isEmpty {
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

    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taggedPlaces = taggedPlaces, !taggedPlaces.isEmpty else { return }
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
}

// MARK: Search Bar Delegate:
extension ListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let firstThreeLettersPlaceNameArray = taggedPlaces?.filter { tagedPlace -> Bool in
            guard let searchBarText = searchBar.text else { return false }
            return tagedPlace.place.name.lowercased().hasPrefix(searchBarText.lowercased())
        }
        taggedPlaces = firstThreeLettersPlaceNameArray
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        taggedPlaces = immutableInitialListOfTaggedPlaces
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == true {
            taggedPlaces = immutableInitialListOfTaggedPlaces
        }
    }
}
