//
//  WeatherViewDelegate.swift
//  Weather Test
//
//  Created by Walter Smith on 10/25/24.
//
// This is the VM. I am tying everything together with delegates.

import Foundation
import UIKit

protocol WVDDelegate {
    func weatherDidChange(_ wvd: WeatherViewDelegate) -> Void
}

class WeatherViewDelegate: ObservableObject, LocationServiceDelegate,WeatherServiceDelegate{
    
    // weather information for shipping to the view
    @Published var cityTemp:String
    @Published var cityName:String
    @Published var weatherDetails:String
    @Published var url: URL?
    
    // vars
    var weatherCity : WeatherCity = WeatherCity()
    var weatherService: WeatherService = WeatherService()
    var locationService: LocationService?
    var cities: [CityName]?
    var delegate : WVDDelegate?
    
    // giving the vars dummy values
    init() {
        cityName = "User City"
        weatherDetails="weather details"
        cityTemp="0.0°"
        
        weatherService.delegate = self
        updateWeather()
    }
    
    // saves current city to usesr defaults so it will show up when the app is next loaded
    func saveCity() {
        let userDefaults = UserDefaults()
        if let lat = self.weatherCity.city?.lat{
            if let lon = self.weatherCity.city?.lon {
                userDefaults.set([lat,lon], forKey: "weatherCity")
            }
        }
    }
    
    //loads previous city when app loads
    func loadCity() -> Bool{
        let userDefaults = UserDefaults()
        if let location = userDefaults.array(forKey: "weatherCity") {
            let lat:Double = location[0] as! Double
            let lon:Double = location[1] as! Double
            weatherService.getWeather(lat:lat, lon:lon)
            return true
        }
        return false
    }
    // delegate from weather model. triggered when weather api is loaded
    func weatherDidChange(_ service: WeatherService) {
        self.weatherCity = service.weatherCity
        
        if let city = self.weatherCity.city {
            saveCity()
            delegate?.weatherDidChange(self)
            if let state = city.state {
                self.cityName = "\(city.name), \(state)"
            } else {
                self.cityName = "\(city.name)"
            }
        } else {
            //self.cityName = "User City"
            print("name failure")
        }
        if let weather = self.weatherCity.weather {
            self.weatherDetails = weather.weather[0].description
            self.cityTemp = String(weather.main.temp) + "°"
        } else {
            print("details failure")
        }
        if let icon = self.weatherCity.weather?.weather[0].icon {
            guard let url = URL(string:"https://openweathermap.org/img/wn/\(icon)@2x.png") else {return}
            self.url = url
        } else {
            print("icon failure")
        }
        
        if let _ = weatherCity.cities {
            if ( service.weatherCity.city == nil) {
                delegate?.weatherDidChange(self)
                return
            }
        } else {
            cities = [CityName]()
        }
    }
    
    // delegate from location model
    func locationDidChange(_ location: LocationService) {
        self.weatherCity = location.weatherCity
        if let city = self.weatherCity.city {
            self.cityName = city.name
        } else {
            //self.cityName = "User City"
            print("name failure")
        }
        if let weather = self.weatherCity.weather {
            self.weatherDetails = weather.weather[0].description
            self.cityTemp = String(weather.main.temp) + "°"
        } else {
            print("details failure")
        }
        if let icon = self.weatherCity.weather?.weather[0].icon {
            guard let url = URL(string:"https://openweathermap.org/img/wn/\(icon)@2x.png") else {return}
            self.url = url
        } else {
            print("icon failure")
        }
        saveCity()
    }
    // should be called, "init weather" loads initial weather from location or previous city.
    func updateWeather() {
        if loadCity() {
            return
        }
        if locationService == nil {
            let locationService = LocationService()
            locationService.delegate = self
            locationService.checkLocationPermission()
        }
    }
    
    // parses the query string and searches for weather.
    func getWeather(query:String) {
        
        //I just love regex, don't you?
        let cityAndState = /([\w\s]+)\s*,\s*([\w\s]+)$/
        let city = /([\w\s]+)$/
        let cityCoords = /([\d\.-]+)\s*,\s*([\d\.-]+)$/
        let zipCoords = /\s*(\d+)\s*$/
        
        if let match = query.firstMatch(of: cityCoords) {
            weatherService.getWeather(lat:Double(String(match.1)) ?? 0.0, lon:Double(String(match.2)) ?? 0.0)
        } else
        if let match = query.firstMatch(of: zipCoords) {
            weatherService.getWeather(zip:Int(String(match.1)) ?? 0)
        } else
        if let match = query.firstMatch(of: cityAndState) {
            var city = String(match.1)
            city.replace(" ", with:"+")
            var state = String(match.2)
            state.replace(" ", with:"+")
            
            weatherService.getWeather(city:city,state:state)
        } else
        if let match = query.firstMatch(of: city) {
            var city = String(match.1)
            city.replace(" ", with:"+")
            
            weatherService.getWeather(city:city)
        }
    }
}
