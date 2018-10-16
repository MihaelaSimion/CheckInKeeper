//
//  DetailsTableViewController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/27/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {
    var taggedPlace: TaggedPlace?
    var cellConfiguration: [CellDetailType] = [.name, .date, .city, .country, .street, .latitude, .longitude]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Check-in details:"
        tableView.backgroundColor = Constants.Colors.backgroundColor
    }

    // MARK: Table view data source:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfiguration.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taggedPlace = taggedPlace else { return UITableViewCell() }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapViewCell", for: indexPath) as? MapTableViewCell
            cell?.configureCell(taggedPlace: taggedPlace)
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as? DetailTableViewCell
            cell?.configureDetailCell(taggedPlace: taggedPlace, cellDetailType: cellConfiguration[indexPath.row - 1])
            cell?.selectionStyle = .none
            cell?.layoutIfNeeded()
            return cell ?? UITableViewCell()
        }
    }
}
