//
//  BeaconsTableViewController.swift
//  Home Aid
//
//  Created by Albrecht Oster on 24.02.18.
//

import UIKit
import CoreLocation

class BeaconsTableViewController: UITableViewController {
    
    static let beacons = [Beacon(uuid: "74278bda-b644-4520-8f0c-720eaf059935", identifier: "Door")]
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        for beacon in BeaconsTableViewController.beacons {
            if let region = beacon?.asBeaconRegion() {
                locationManager.startRangingBeacons(in: region)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BeaconsTableViewController.beacons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "beaconCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "beaconCell")
        }
        
        if let beacon = BeaconsTableViewController.beacons[indexPath.row] {
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

// MARK: - Location Manager delegate

extension BeaconsTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for clBeacon in beacons {
            if clBeacon.accuracy < 0 { continue }
            for beacon in BeaconsTableViewController.beacons {
                if beacon != nil && beacon! == clBeacon {
                    beacon!.distance = clBeacon.accuracy
                    print("\(clBeacon.accuracy) m, \(clBeacon.proximity)")
                    break
                }
            }
        }
        self.tableView.reloadData()
    }
    
}
