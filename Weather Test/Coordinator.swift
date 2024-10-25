//
//  Coordinator.swift
//  Weather Test
//
//  Created by Walter Smith on 10/25/24.
//

import Foundation
import UIKit
import SwiftUI

protocol Coordinator {
    func showDetail(_ wvd:WeatherViewDelegate) -> Void
    func setup() -> Void
}


struct ViewCoord: Coordinator {
    var nav:UINavigationController
    
    init(_ nav:UINavigationController) {
        self.nav = nav
    }
    func setup() {
        let vc = ViewController()
        vc.viewCoord = self
        nav.setViewControllers([vc], animated: false)
    }
    func showDetail(_ wvd:WeatherViewDelegate) {
        let vc = UIHostingController(rootView:WeatherDetailView(wvd: wvd))
        vc.title = "Weather Details"
        nav.pushViewController(vc, animated: true)
    }
    
    
}
