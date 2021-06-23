//
//  WeatherService.swift
//  WeatherApp
//

import Foundation

class WeatherService {
    static var shared = WeatherService()
    
    private var cachedItems = [String: Weather]()
    
    private let networkManager = NetworkManager()
    private let apiToken = "a68c98b4b3a026c0a1d4c9e9966ee828"
    
    func fetchCityWeather(for city: String, completionHandler: @escaping (Weather?, String?) -> Void) {
        let requestUrl = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiToken)&units=metric&lang=ru"
        
        if let cachedItem = cachedItems[requestUrl] {
            completionHandler(cachedItem, nil)
        }
        
        networkManager.httpGetRequest(url: requestUrl) { (response: NetworkManagerResponse<Weather>) in
            // пришел ответ
            switch response {
            case .success(let weather):
                self.cachedItems[requestUrl] = weather
                
                completionHandler(weather, nil)
            case .failure(_, let message):
                completionHandler(nil, message)
            }
        }
    }
    
    private init() { }
}
