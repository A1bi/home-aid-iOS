//
//  BeaconManager.swift
//  Home Aid
//
//  Created by Albrecht Oster on 24.02.18.
//

import Foundation
import UIKit
import CoreLocation
import os.log

typealias BeaconManagerUpdateHandler = () -> ()
typealias BeaconManagerApproachingDoorHandler = () -> ()

class BeaconManager: NSObject {
    static let shared = BeaconManager()

    static let beaconUUID = "74278bda-b644-4520-8f0c-720eaf059935"
    static let doorLocation = CLLocationCoordinate2D(latitude: 52.566118, longitude: 13.325902)
    static let doorLocationRadius = 50.0

    var beacons = [CLBeacon]()
    private let beaconRegion: CLBeaconRegion
    private let geoRegion: CLCircularRegion
    private let locationManager = CLLocationManager()
    private var updateHandlers = [BeaconManagerUpdateHandler]()
    private var approachingDoorHandler: BeaconManagerApproachingDoorHandler?
    private var backgroundTask: UIBackgroundTaskIdentifier?
    private var doorAlreadyRanged = false
    private var rangingEntities = 0
    
    override init() {
        let uuid = UUID(uuidString: BeaconManager.beaconUUID)
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "DoorBeacon")

        geoRegion = CLCircularRegion(center: BeaconManager.doorLocation, radius: BeaconManager.doorLocationRadius, identifier: "Door")

        super.init()

        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }

    func startMonitoringGeoRegion() {
        locationManager.startMonitoring(for: self.geoRegion)
    }

    func startRangingForBeacons() {
        if (rangingEntities < 1) {
            locationManager.startRangingBeacons(in: self.beaconRegion)
        }
        rangingEntities += 1
    }

    private func startRangingForBeaconsInBackground() {
        doorAlreadyRanged = false

        self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.stopRangingForBeaconsInBackground()
        })

        os_log("Ranging in background started.", log: OSLog.default, type: .info)

        self.startRangingForBeacons()
    }

    func stopRangingForBeacons() {
        rangingEntities -= 1
        if (rangingEntities < 1) {
            locationManager.stopRangingBeacons(in: self.beaconRegion)
        }
    }

    private func stopRangingForBeaconsInBackground() {
        self.stopRangingForBeacons()

        if let backgroundTask = self.backgroundTask {
            os_log("Ranging in background stopped.", log: OSLog.default, type: .info)

            UIApplication.shared.endBackgroundTask(backgroundTask)
            self.backgroundTask = nil
        }
    }
    
    func didUpdateBeacons(_ handler: @escaping BeaconManagerUpdateHandler) {
        self.updateHandlers.append(handler)
    }

    func approachingDoor(_ handler: @escaping BeaconManagerApproachingDoorHandler) {
        self.approachingDoorHandler = handler
    }

}

// MARK: - location manager delegate

extension BeaconManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if (region == self.geoRegion) {
            self.startRangingForBeaconsInBackground()
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if (region == self.geoRegion) {
            self.stopRangingForBeaconsInBackground()
        }
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.beacons = beacons
        
        for handler in self.updateHandlers {
            handler()
        }

        if !doorAlreadyRanged, backgroundTask != nil, beacons.count > 0 {
            doorAlreadyRanged = true

            if let handler = self.approachingDoorHandler {
                handler()
            }

            os_log("Ranged door in background. Triggering handler.", log: OSLog.default, type: .info)

            self.stopRangingForBeaconsInBackground()
        }
    }
}
