//
//  WeatherService.swift
//  Weather Test
//
//  Created by Walter Smith on 10/25/24.
//
// consumes weather APIs
//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
//http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=368940b0edf5e826c673034af78735ec
//https://api.openweathermap.org/data/2.5/weather?id={city id}&appid={API key}

import Foundation

let api_key:String = "368940b0edf5e826c673034af78735ec"

protocol WeatherServiceDelegate {
    func weatherDidChange(_ service:WeatherService)->Void
}

class WeatherService: NSObject, GeocodingServiceDelegate {
    var weatherCity = WeatherCity()
    var cities : [CityName]
    var delegate : WeatherServiceDelegate?
    let geocodingService = GeocodingService()
    
    override init() {
        self.cities = [CityName]()
        super.init()
        self.geocodingService.delegate = self;
    }
    
    func weatherCityDidChange(_ service: GeocodingService) {
        self.weatherCity.city = service.weatherCity.city
        self.weatherCity.cities = service.weatherCity.cities
        
        if let city = weatherCity.city {
            self.weatherCity.cities = nil
            actuallyGetWeather(lat:city.lat, lon:city.lon)
            return
        }
        if let cities = weatherCity.cities {
            if cities.count > 1 {
                delegate?.weatherDidChange(self)
                return
            } else if !cities.isEmpty {
                self.weatherCity.cities = nil
                actuallyGetWeather(lat:cities[0].lat, lon:cities[0].lon)
            }
        }
    }
    func actuallyGetWeather(lat:Double, lon:Double) {
        //print("actually getting weather")
        guard let url =
                URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&appid=\(api_key)") else {return}
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let data = data {
                do {
                    let cityWeather = try JSONDecoder().decode(CityWeather.self, from:data)
                    self?.weatherCity.weather = cityWeather
                    DispatchQueue.main.async {
                        if let delegate = self?.delegate {
                            delegate.weatherDidChange(self!)
                        }
                    }
                } catch {
                    print(error)
                }
            } else {
                print("actually get weather error")
            }
        }
        task.resume()
    }
    func getWeather (city:String) {
        geocodingService.getCity(city: city)
    }
    func getWeather (city:String,state:String) {
        geocodingService.getCity(city: city, state:state)
    }
    func getWeather(lat:Double, lon:Double) {
        geocodingService.getCity(lat,lon)
    }
    func getWeather (zip:Int) {
        geocodingService.getCity(zip:zip)
    }
}
