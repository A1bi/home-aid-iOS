//
//  BeaconsTableViewController.swift
//  Home Aid
//
//  Created by Albrecht Oster on 24.02.18.
//

import UIKit
import CoreLocation

class BeaconsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BeaconManager.shared.didUpdateBeacons {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BeaconManager.shared.beacons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "beaconCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "beaconCell")
        }
        
        if let beacon = BeaconManager.shared.beacons[indexPath.row] {
            cell?.textLabel?.text = beacon.identifier
            if let distance = beacon.distance {
                let lengthFormatter = LengthFormatter()
                lengthFormatter.unitStyle = .medium
                cell?.detailTextLabel?.text = lengthFormatter.string(fromValue: distance, unit: .meter)
            }
        }

        return cell!
    }
    
}
