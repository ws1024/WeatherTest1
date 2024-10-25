//
//  LocationService.swift
//  Weather Test
//
//  Created by Walter Smith on 10/25/24.
//
// determines user location with CoreLocation

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func locationDidChange(_ location:LocationService) -> Void
}

class LocationService: NSObject, CLLocationManagerDelegate,WeatherServiceDelegate {

    let locationManager : CLLocationManager
    let weatherService = WeatherService()
    var weatherCity = WeatherCity()
    var delegate : LocationServiceDelegate?
    
    func weatherDidChange(_ service: WeatherService) {
        //print("weather did change")
        weatherCity = service.weatherCity
        delegate?.locationDidChange(self)
    }
    override init() {
        self.locationManager = CLLocationManager();
        super.init()
        locationManager.delegate = self;
        weatherService.delegate = self;
    }
    func checkLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            fallthrough
        case .restricted:
            fallthrough
        case .denied:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            if let location = locationManager.location {
                weatherService.getWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
        @unknown default:
            print("error unknown state")
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            fallthrough
        case .restricted:
            fallthrough
        case .denied:
            break
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            let location : CLLocation? = locationManager.location
            self.weatherService.getWeather(lat: location?.coordinate.latitude ?? 0.0, lon: location?.coordinate.longitude ?? 0.0)
        @unknown default:
            print("error unknown state")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location : CLLocation? = locationManager.location
        self.weatherService.getWeather(lat: location?.coordinate.latitude ?? 0.0, lon: location?.coordinate.longitude ?? 0.0)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        return
    }
}
