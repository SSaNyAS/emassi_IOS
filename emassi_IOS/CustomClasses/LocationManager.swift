//
//  LocationManager.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 01.10.2022.
//

import Foundation
import CoreLocation

class LocationManager:NSObject, CLLocationManagerDelegate {
    let locationManager: CLLocationManager
    public var currentLocation: CLLocation?
    public var monitoringState: MonitoringState = .getOneLocation
    public private(set) var authorizationStatus: CLAuthorizationStatus
    
    public var didFailGetLocation: ((Error) -> Void)?
    public var didCompleteGetLocation: ((CLLocation) -> Void)?
    
    override init(){
        self.locationManager = CLLocationManager()
        
        if #available(iOS 14.0, *) {
            self.authorizationStatus = locationManager.authorizationStatus
        } else {
            self.authorizationStatus = .notDetermined
        }
        
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStatus(status: status)
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus(status: manager.authorizationStatus)
    }
    
    func checkAuthorizationStatus(status: CLAuthorizationStatus){
        switch status {
        case .notDetermined, .denied, .restricted:
            stopUpdateLocations()
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            
            break
        @unknown default:
            break
        }
        self.authorizationStatus = status
    }
    
    func stopUpdateLocations(){
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdateLocations(){
        locationManager.startUpdatingLocation()
        checkAuthorizationStatus(status: authorizationStatus)
    }
    
    
    func getCurrentLocation(completion: @escaping (CLLocation?) -> Void){
        locationManager.requestLocation()
        completion(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        didFailGetLocation?(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print(error?.localizedDescription ?? "")
        if let error = error{
            didFailGetLocation?(error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last{
            self.currentLocation = currentLocation
            didCompleteGetLocation?(currentLocation)
            if monitoringState == .getOneLocation {
                manager.stopUpdatingLocation()
            }
        }
    }
    
    enum MonitoringState{
        case getOneLocation
        case monitoring
    }
}
