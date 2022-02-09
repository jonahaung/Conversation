//
//  LocationManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import CoreLocation

import CoreLocation

//-----------------------------------------------------------------------------------------------------------------------------------------------
class Location: NSObject, ObservableObject, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager?
    @Published var location = CLLocation()

    //-------------------------------------------------------------------------------------------------------------------------------------------
    static let shared: Location = {
        let instance = Location()
        return instance
    } ()

    //-------------------------------------------------------------------------------------------------------------------------------------------
    class func setup() {

        _ = shared
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    class func start() {

        shared.locationManager?.startUpdatingLocation()
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    class func stop() {

        shared.locationManager?.stopUpdatingLocation()
        print("stopped")
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
     func address(completion: @escaping (String?, String?, String?) -> Void) {

        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                completion(placemark.locality, placemark.country, placemark.isoCountryCode)
            } else {
                completion(nil, nil, nil)
            }
        }
    }

    // MARK: - Instance methods
    //-------------------------------------------------------------------------------------------------------------------------------------------
    override init() {

        super.init()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }

    // MARK: - CLLocationManagerDelegate
    //-------------------------------------------------------------------------------------------------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            self.location = location
        }
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
}

//class LocationManager: NSObject, ObservableObject {
//
//    
//    @Published var currentLocation = CLLocationCoordinate2D(latitude: 45.8827419, longitude: -1.1932383)
//    
//    private let locationManager = CLLocationManager()
//    override init() {
//        super.init()
//    
//        if locationManager.authorizationStatus != .authorizedWhenInUse {
//            locationManager.requestWhenInUseAuthorization()
//        }
//        
//        locationManager.startUpdatingLocation()
//        
//        locationManager.delegate = self
//    }
//    
//    deinit {
//        locationManager.stopUpdatingLocation()
//        print("locationManager deinit")
//    }
//}
//
//extension LocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.currentLocation = locations.last?.coordinate ?? CLLocationCoordinate2D(latitude: 45.8827419, longitude: -1.1932383)
//        manager.stopUpdatingLocation()
//    }
//
//    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location manager failed with error: \(error.localizedDescription)")
//    }
//
//    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("Location manager changed the status: \(status.rawValue)")
//    }
//}
