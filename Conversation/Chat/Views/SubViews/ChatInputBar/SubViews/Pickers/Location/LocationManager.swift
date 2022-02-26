//
//  LocationManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import CoreLocation

class Location: NSObject, ObservableObject, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager?
    var location = CLLocation()
    @Published var address: String = String()

    func start() {
        locationManager?.startUpdatingLocation()
    }

    func stop() {
        locationManager?.stopUpdatingLocation()
        print("stopped")
    }

    override init() {
        super.init()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            manager.stopUpdatingHeading()
            self.location = location
            CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
                guard let self = self else { return }
                if let placemark = placemarks?.first {
                    var address = ""
                    if let locality = placemark.locality {
                        address = locality
                    }
                    if let country = placemark.country {
                        address += ", " + country
                    }
                    if let isoCountryCode = placemark.isoCountryCode {
                        address += ", " + isoCountryCode
                    }
                    self.address = address
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
    
    deinit {
        Log("Deinit")
    }
}
