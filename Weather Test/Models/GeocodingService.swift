//
//  GeocodingService.swift
//  Weather Test
//
//  Created by Walter Smith on 10/25/24.
//
//consumes geocoding api
// http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}

import Foundation
import Combine

protocol GeocodingServiceDelegate {
    func weatherCityDidChange(_ service:GeocodingService) -> Void
}

class GeocodingService {
    var weatherCity = WeatherCity()
    var delegate : GeocodingServiceDelegate?
    var cancellables : Set<AnyCancellable>
    
    init(weatherCity: WeatherCity = WeatherCity(), delegate: GeocodingServiceDelegate? = nil, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.weatherCity = weatherCity
        self.delegate = delegate
        self.cancellables = cancellables
    }
    
    func getCity(city:String,state:String,limit:Int=10) {
        guard let url = URL(string:"https://api.openweathermap.org/geo/1.0/direct?q=\(city),\(state)&limit=\(limit)&appid=\(api_key)") else {
            print("url error")
            return
            
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            
                self?.weatherCity.city = nil
            if let data = data {
                do {
                    let cityNames = try JSONDecoder().decode([CityName].self, from:data)
                    if cityNames.count > 1 {
                        self?.weatherCity.cities = cityNames
                    } else if cityNames.count == 1 {
                        self?.weatherCity.city = cityNames[0]
                    }
                    DispatchQueue.main.async {self?.delegate?.weatherCityDidChange(self!)}
                } catch {
                    print(error)
                }
            } else {
                
            }
        }
        task.resume()
    }
    func getCity(city:String,limit:Int=10) {
        guard let url = URL(string:"https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=\(limit)&appid=\(api_key)") else {return}
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            
                self?.weatherCity.city = nil
            if let data = data {
                do {
                    let cityNames = try JSONDecoder().decode([CityName].self, from:data)
                    if cityNames.count > 1 {
                        self?.weatherCity.cities = cityNames
                    } else if cityNames.count == 1 {
                        self?.weatherCity.city = cityNames[0]
                    }
                    DispatchQueue.main.async {self?.delegate?.weatherCityDidChange(self!)}
                } catch {
                    print(error)
                }
            } else {
                
            }
        }
        task.resume()
    }
    func getCity(_ lat:Double,_ lon:Double, limit:Int = 10) {
        guard let url = URL(string:"https://api.openweathermap.org/geo/1.0/reverse?lat=\(lat)&lon=\(lon)&limit=\(limit)&appid=\(api_key)") else {return}
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            
                self?.weatherCity.city = nil
            if let data = data {
                do {
                    let cityNames = try JSONDecoder().decode([CityName].self, from:data)
                    if cityNames.count > 1 {
                        self?.weatherCity.cities = cityNames
                    } else if cityNames.count == 1 {
                        self?.weatherCity.city = cityNames[0]
                    }
                    DispatchQueue.main.async {self?.delegate?.weatherCityDidChange(self!)}
                } catch {
                    print(error)
                    
                }
            } else {
                print ("name lookup error")
            }
        }
        task.resume()
    }
    func getCity(zip:Int) {
        getCityCombine(zip)
        return
        guard let url = URL(string:"https://api.openweathermap.org/geo/1.0/zip?zip=\(zip),US&appid=\(api_key)") else {return}
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            
                self?.weatherCity.city = nil
            if let data = data {
                do {
                    let city = try JSONDecoder().decode(CityName.self, from:data)
                    self?.weatherCity.city = city
                    DispatchQueue.main.async {
                        self?.delegate?.weatherCityDidChange(self!)
                        
                    }
                } catch {
                    print(error)
                }
            } else {
                
            }
        }
        task.resume()
    }
    func getCityCombine(_ zip:Int) {
        guard let url = URL(string:"https://api.openweathermap.org/geo/1.0/zip?zip=\(zip),US&appid=\(api_key)") else {return}
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap() { element->Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {throw URLError(.badServerResponse)}
                return element.data
            }.decode(type: CityName.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
             .sink(
                receiveCompletion: { print("\($0)")},
                receiveValue: {[weak self] cityName in
                    self?.weatherCity.city = cityName
                    self?.delegate?.weatherCityDidChange(self!)
                }
            )
             .store(in: &cancellables)
    }
}
