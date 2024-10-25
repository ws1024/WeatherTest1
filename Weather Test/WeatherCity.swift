//
//  WeatherCity.swift
//  Weather Test
//
//  Created by Walter Smith on 10/25/24.
//
// Here we have all the codables

import Foundation
struct Coord : Decodable {
    let lon: Double
    let lat: Double
}
struct Main : Decodable {
    let temp: Double
    let pressure: Int
    let humidity: Int
    let feels_like: Double
}
struct Weather : Decodable {
    //let id : Int
    let description: String
    let icon : String
}
struct Wind : Decodable {
    let speed: Double
    let deg: Int
}
class CityWeather : Decodable, Equatable
{
    static func == (lhs: CityWeather, rhs: CityWeather) -> Bool {
        return lhs.coord.lat == rhs.coord.lat && lhs.coord.lon == rhs.coord.lon
    }
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let visibility: Int
}
class CityName : Decodable, Equatable {
    static func == (lhs: CityName, rhs: CityName) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
    let name: String
    let country: String
    let state: String?
    let lat: Double
    let lon: Double
}
class WeatherCity{//: Equatable {
    //static func == (lhs: WeatherCity, rhs: WeatherCity) -> Bool {
    //    return lhs.city == rhs.city && lhs.city == rhs.city
    //}
    
    var city: CityName?
    var cities: [CityName]?
    var weather: CityWeather?
}
