//
//  Beacon.swift
//  Home Aid
//
//  Created by Albrecht Oster on 24.02.18.
//

import Foundation
import CoreLocation

class Beacon {
    let uuid: UUID
    let identifier: String
    var distance: CLLocationAccuracy?
    
    init?(uuid: String, identifier: String) {
        guard let u = UUID(uuidString: uuid) else {
            return nil
        }
        self.uuid = u
        self.identifier = identifier
    }
    
    func asBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: self.uuid, identifier: identifier)
    }
    
    static func ==(beacon: Beacon, clBeacon: CLBeacon) -> Bool {
        return beacon.uuid.uuidString == clBeacon.proximityUUID.uuidString;
    }
}
