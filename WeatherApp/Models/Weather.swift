//
//  Weather.swift
//  WeatherApp
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let weather: [WeatherElement]
    let main: Main
    let name: String
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let weatherDescription, icon: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}

