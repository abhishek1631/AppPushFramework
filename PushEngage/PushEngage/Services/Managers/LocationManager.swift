//
//  LocationManager.swift
//  PushFramework
//
//  Created by Abhishek on 14/03/21.
//

import Foundation
import CoreLocation

typealias GeoLocationInfo = (country : String? , state : String? , locality : String?)

class LocationManager : NSObject , CLLocationManagerDelegate , LocationInfoProtocol {
    
    private var locationManager : CLLocationManager?
    
    var locationInfoObserver = Variable<GeoLocationInfo>((nil , nil , nil))
    
    override init() {
        super.init()
        self.locationSetup()
    }
    
    private func locationSetup() {
        if Utility.isLocationPrivcyEnabled {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = CLLocationDistanceMax
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard  let last = locations.last  else {
            return
        }
        var changedLocationInfo : (country : String? , state : String? , locality : String?) = (nil, nil
         , nil)
        getPlace(for: last) { [weak self] (placemakers) in
            DispatchQueue.main.async {
                if let country = placemakers?.country {
                    changedLocationInfo.country = country
                }
                
                if let locality = placemakers?.locality {
                    changedLocationInfo.locality = locality
                }
                
                if let state = placemakers?.administrativeArea {
                    changedLocationInfo.state = state
                }
                self?.locationInfoObserver.value = changedLocationInfo
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
        case .denied,.notDetermined,.restricted:
            PELogger.debug(className: String(describing: LocationManager.self), message: "Location services denied")
        @unknown default:
            PELogger.debug(className: String(describing: LocationManager.self), message: "unknown")
            print("unknown")
        }
    }
    
}

extension LocationManager {
    
    private func getPlace(for location : CLLocation ,completion :@escaping (CLPlacemark?) -> Void ) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self](placemarks, error) in
            guard  error == nil else {
                PELogger.error(className: String(describing: LocationManager.self), message: error.debugDescription)
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                PELogger.error(className: String(describing: LocationManager.self), message: error.debugDescription)
                completion(nil)
                return
            }
            self?.locationManager?.stopUpdatingLocation()
            completion(placemark)
        }
    }
}
