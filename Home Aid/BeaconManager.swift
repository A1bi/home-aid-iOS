//
//  BeaconManager.swift
//  Home Aid
//
//  Created by Albrecht Oster on 24.02.18.
//

import Foundation
import CoreLocation
import UserNotifications

typealias BeaconManagerUpdateHandler = () -> ()
typealias BeaconManagerDoorProximityHandler = (CLBeacon) -> ()

class BeaconManager: NSObject {
    static let shared = BeaconManager()

    static let beaconUUID = "74278bda-b644-4520-8f0c-720eaf059935"

    var beacons = [CLBeacon]()
    private let beaconRegion: CLBeaconRegion
    private let locationManager = CLLocationManager()
    private var updateHandlers = [BeaconManagerUpdateHandler]()
    private var approachingDoorHandler: BeaconManagerDoorProximityHandler?
    
    override init() {
        let uuid = UUID(uuidString: BeaconManager.beaconUUID)
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "Door")

        super.init()

        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }

    func startMonitoring() {
        locationManager.startMonitoring(for: self.beaconRegion)
    }

    func startRanging() {
        locationManager.startRangingBeacons(in: self.beaconRegion)
    }

    func stopRanging() {
        locationManager.stopRangingBeacons(in: self.beaconRegion)
    }
    
    func didUpdateBeacons(_ handler: @escaping BeaconManagerUpdateHandler) {
        self.updateHandlers.append(handler)
    }

    func approachingDoor(_ handler: @escaping BeaconManagerDoorProximityHandler) {
        self.approachingDoorHandler = handler
    }

}

// MARK: - location manager delegate

extension BeaconManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        HomeAidManager.shared.openDoor()

        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("beaconManager.doorInRangeNotification.title", comment: "")
        content.body = NSLocalizedString("beaconManager.doorInRangeNotification.body", comment: "")
        content.sound = .default()

        let request = UNNotificationRequest(identifier: "doorInRange", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("beaconManager.doorOutOfRangeNotification.title", comment: "")
        content.body = NSLocalizedString("beaconManager.doorOutOfRangeNotification.body", comment: "")
        content.sound = .default()

        let request = UNNotificationRequest(identifier: "doorOutOfRange", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.beacons = beacons
        
        for handler in self.updateHandlers {
            handler()
        }
    }
}
