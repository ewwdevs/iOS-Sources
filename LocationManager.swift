//
//  LocationManager.swift
//  DPS
//
//  Created by Gaurang on 06/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit
import Combine

protocol LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateLocation mostRecentLocation: CLLocation)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private lazy var locationManager = CLLocationManager()
    
    /// - Note: Use for Combine and SwiftUI otherwise remove this
    let locationUpdateSubject = PassthroughSubject<CLLocation, Never>()

    /// - Note: For UIKit
    var delegate: LocationManagerDelegate?

    var mostRecentLocation: CLLocation?

    var speed: CLLocationSpeed? {
        locationManager.location?.speed
    }

    var coordinates: CLLocationCoordinate2D? {
        mostRecentLocation?.coordinate
    }

    var direction: CLLocationDirection {
        mostRecentLocation?.course ?? 0
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.locationManager.requestAlwaysAuthorization()
        }
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        self.mostRecentLocation = mostRecentLocation
        locationUpdateSubject.send(mostRecentLocation)
        delegate?.locationManager(self, didUpdateLocation: mostRecentLocation)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.openSettingsDialog()
            }
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            manager.startUpdatingLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }

    private func openSettingsDialog() {
        let message = "Please allow \(Helper.appName) to access location for fetching you location info."
        let alertVC = UIAlertController(title: "Essential!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsAppURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        AppDelegate.current.window?.rootViewController?.present(alertVC, animated: true)
    }
}
