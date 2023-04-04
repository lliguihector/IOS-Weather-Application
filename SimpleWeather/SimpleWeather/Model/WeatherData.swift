//
//  WeatherData.swift
//  SimpleWeather
//
//  Created by Hector Lliguichuzca on 4/3/23.
//

import Foundation

struct WeatherData: Codable{
    
    let name: String
    let main: Main
    let weather: [Weather]
    
    
    struct Main: Codable{
        let temp: Double
    }
    
    struct Weather: Codable{
        let description: String
        let id: Int
    }
 
    
}
