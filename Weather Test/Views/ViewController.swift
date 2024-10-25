//
//  ViewController.swift
//  Weather Test
//
//  Created by Walter Smith on 10/25/24.
//

import UIKit
import SwiftUI


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WVDDelegate {

    var viewCoord : Coordinator?
    let queryBox: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .white
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    let goButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Weather", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8.0
        return button
    }()

    let promptLabel: UILabel = {
        let label = UILabel()
        label.text = "Type City as <zip>, <City, State>, or <lat,lon>"
        label.backgroundColor = .white
        return label
    }()

    
    let detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show Details", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8.0
        return button
    }()

    var weatherViewController = UIHostingController(rootView: WeatherView())
    var citiesSelector = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Weather"
        
        
        goButton.addTarget(self, action: #selector(go), for: .touchUpInside)
        detailButton.addTarget(self, action: #selector(detail), for: .touchUpInside)
        
        weatherViewController.rootView.wvd.delegate = self
        citiesSelector.delegate = self
        citiesSelector.dataSource = self
        citiesSelector.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")

        
        addChild(weatherViewController)
        
        self.view.addSubview(weatherViewController.view)
        self.view.addSubview(citiesSelector)
        self.view.addSubview(goButton)
        self.view.addSubview(promptLabel)
        self.view.addSubview(queryBox)
        self.view.addSubview(detailButton)
        
        let constraints = [
            weatherViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherViewController.view.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            weatherViewController.view.widthAnchor.constraint(equalToConstant: 400.0),
            weatherViewController.view.heightAnchor.constraint(equalToConstant: 200.0),
            promptLabel.topAnchor.constraint(equalTo: view.centerYAnchor),
            promptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptLabel.widthAnchor.constraint(equalToConstant: 380.0),
            promptLabel.heightAnchor.constraint(equalToConstant: 44.0),
            goButton.topAnchor.constraint(equalTo: promptLabel.bottomAnchor),
            goButton.trailingAnchor.constraint(equalTo: promptLabel.centerXAnchor, constant: 20.0),
            detailButton.topAnchor.constraint(equalTo: goButton.topAnchor),
            detailButton.trailingAnchor.constraint(equalTo:goButton.leadingAnchor, constant: -10.0),
            queryBox.topAnchor.constraint(equalTo: promptLabel.bottomAnchor),
            queryBox.leadingAnchor.constraint(equalTo: promptLabel.centerXAnchor, constant: 30.0),
            queryBox.widthAnchor.constraint(equalToConstant: 150.0),
            citiesSelector.topAnchor.constraint(equalTo: queryBox.bottomAnchor),
            citiesSelector.leadingAnchor.constraint(equalTo: queryBox.leadingAnchor),
            citiesSelector.heightAnchor.constraint(equalToConstant: 400.0),
            citiesSelector.widthAnchor.constraint(equalToConstant: 200.0),
        ]
        
        weatherViewController.view.translatesAutoresizingMaskIntoConstraints = false
        citiesSelector.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        goButton.translatesAutoresizingMaskIntoConstraints = false
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        queryBox.translatesAutoresizingMaskIntoConstraints = false
        citiesSelector.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cities = weatherViewController.rootView.wvd.weatherCity.cities
        return cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")
        if let cities = weatherViewController.rootView.wvd.weatherCity.cities {
            let name = cities[indexPath.row].name
            if let state = cities[indexPath.row].state {
                cell?.textLabel?.text = "\(name), \(state)"
            } else {
                cell?.textLabel?.text = name
            }
        }
            
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cities = weatherViewController.rootView.wvd.weatherCity.cities {
            let lat = cities[indexPath.row].lat
            let lon = cities[indexPath.row].lon
            weatherViewController.rootView.wvd.getWeather(query: "\(lat), \(lon)")
        }
    }
    func weatherDidChange(_ wvd: WeatherViewDelegate) {
        citiesSelector.reloadData()
    }
    @objc func go() {
        if (queryBox.text?.count ?? 0 > 0) {
            weatherViewController.rootView.wvd.getWeather(query: queryBox.text ?? "")
        }
    }
    @objc func detail() {
        let wvd = weatherViewController.rootView.wvd
        viewCoord?.showDetail(wvd)
    }

}

