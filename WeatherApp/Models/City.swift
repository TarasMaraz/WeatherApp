//
//  TestModel.swift
//  WeatherApp
//
//  Created by SERGEY VOROBEV on 18.06.2021.
//

import Foundation

struct City {
    let cityName: String
    var weatherData: Weather?
    
    static func getDemoCities() -> [City] {
        let data = [
            City(cityName: "Москва", weatherData: nil),
            City(cityName: "Санкт-Петербург", weatherData: nil),
            City(cityName: "Новосибирск", weatherData: nil)
        ]
        
        return data
    }
        
}

enum WeatherUserAction: String {
    case wearVeryWarmClothes = "Рекмендуем одеть две пары носков, штаны с начесом и теплую куртку - на улице холодно🥶"
    case wearWarmClothes = "Рекомендуем одеть демисизонную куртку и штаны - точно не замерзните 😉"
    case wearLightClothes = "Рекомендуем одеть легкую куртку или кофту 💨"
    case eatIceCreamAndSwim = "Рекомендуем раздеться, есть побольше мороженного и купаться ☀️"
}
