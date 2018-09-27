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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCheckinData()
        NotificationCenter.default.addObserver(self, selector: #selector(getCheckinData), name: .taggedPlaceResponseChanged, object: nil)
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
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard taggedPlaces != nil else { return 0 }
        return taggedPlaces!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        if taggedPlaces != nil {
            cell.textLabel?.text = taggedPlaces![indexPath.row].place.name
            cell.detailTextLabel?.text = taggedPlaces![indexPath.row].created_time
            return cell
        } else {
            return cell
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
