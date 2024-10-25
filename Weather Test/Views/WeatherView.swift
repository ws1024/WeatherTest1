//
//  WeatherView.swift
//  Weather Test
//
//  Created by Walter Smith on 10/25/24.
//
// weather widget to insert in UIKit framework.

import SwiftUI

struct WeatherView: View {
    @ObservedObject var wvd:WeatherViewDelegate
    
    init(wvd: WeatherViewDelegate = WeatherViewDelegate(), detail: Bool = false) {
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
            }
            .onTapGesture {
            }
            Spacer()
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
