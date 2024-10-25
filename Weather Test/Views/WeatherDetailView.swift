//
//  WeatherDetailView.swift
//  Weather Test
//
//  Created by Walter Smith on 10/25/24.
//

import SwiftUI

struct WeatherDetailView: View {
    @ObservedObject var wvd:WeatherViewDelegate
    init(wvd: WeatherViewDelegate) {
        self.wvd = wvd
    }
    var body: some View {
        HStack{
            Spacer()
            VStack{
                HStack{
                    Text(wvd.cityName)
                        .font(Font.headline)
                    AsyncImage(url:wvd.url)
                }
                
                HStack {
                    Text(wvd.cityTemp)
                    Text(wvd.weatherDetails)
                        .font(Font.headline)
                }
                HStack {
                    Rectangle()
                       .size(width: 2, height: 240)
                    List {
                        Text("Visibility \(wvd.weatherCity.weather?.visibility ?? 0)m")
                        Text("Wind: \(wvd.weatherCity.weather?.wind.speed ?? 0)  \(wvd.weatherCity.weather?.wind.deg ?? 0)")
                        Text("Feels like \(wvd.weatherCity.weather?.main.feels_like ?? 0)°")
                        Text("Humidity \(wvd.weatherCity.weather?.main.humidity ?? 0)")
                    }
                    .frame(width: 240)
                }.padding(44)
            }
            Spacer()
            
        }
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(wvd: WeatherViewDelegate())
    }
}
