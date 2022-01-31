//
//  LocationManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {

    
    @Published var currentLocation = CLLocationCoordinate2D(latitude: 45.8827419, longitude: -1.1932383)
    
    private let locationManager = CLLocationManager()
    override init() {
        super.init()
    
        if locationManager.authorizationStatus != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        
        locationManager.delegate = self
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
        print("locationManager deinit")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last?.coordinate ?? CLLocationCoordinate2D(latitude: 45.8827419, longitude: -1.1932383)
        manager.stopUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location manager changed the status: \(status.rawValue)")
    }
}
