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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        BeaconManager.shared.startRangingForBeacons()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        BeaconManager.shared.stopRangingForBeacons()
    }
    
    private func nameForProximity(_ proximity: CLProximity) -> String {
        switch proximity {
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        case .unknown:
            return "Unknown"
        @unknown default:
            return "Unknown"
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
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "beaconCell")
        }
        
        let beacon = BeaconManager.shared.beacons[indexPath.row]
        cell?.textLabel?.text = "major: \(beacon.major) | minor: \(beacon.minor)"

        let lengthFormatter = LengthFormatter()
        lengthFormatter.unitStyle = .medium
        
        let distance = lengthFormatter.string(fromValue: beacon.accuracy, unit: .meter)
        let proximity = self.nameForProximity(beacon.proximity)

        cell?.detailTextLabel?.text = "\(proximity) (\(distance))"

        return cell!
    }
    
}
