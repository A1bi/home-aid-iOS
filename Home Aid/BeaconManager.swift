//
//  BeaconManager.swift
//  Home Aid
//
//  Created by Albrecht Oster on 24.02.18.
//

import Foundation
import CoreLocation

typealias BeaconManagerUpdateHandler = () -> ()

class BeaconManager: NSObject {
    static let shared = BeaconManager()
    
    let beacons = [Beacon(uuid: "74278bda-b644-4520-8f0c-720eaf059935", identifier: "Door")]
    private let locationManager = CLLocationManager()
    private var updateHandlers = [BeaconManagerUpdateHandler]()
    
    override init() {
        super.init()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        for beacon in self.beacons {
            if let region = beacon?.asBeaconRegion() {
                locationManager.startRangingBeacons(in: region)
            }
        }
    }
    
    func didUpdateBeacons(_ handler: @escaping BeaconManagerUpdateHandler) {
        updateHandlers.append(handler)
    }
}

extension BeaconManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for clBeacon in beacons {
            if clBeacon.accuracy < 0 { continue }
            for beacon in self.beacons {
                if beacon != nil && beacon! == clBeacon {
                    beacon!.distance = clBeacon.accuracy
                    break
                }
            }
        }
        
        for handler in self.updateHandlers {
            handler()
        }
    }
}
