//
//  WeatherService.swift
//  Weather
//
//  Created by Lydia Lu on 2025/3/14.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case responseError
    case decodingError
}

struct WeatherService {
    // Open-Meteo API的基礎URL
    private let baseURL = "https://api.open-meteo.com/v1/forecast"
    
    // 使用Combine獲取天氣資料
    func getWeather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponse, Error> {
        // 構建URL
        let urlString = "\(baseURL)?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m&hourly=temperature_2m,precipitation_probability&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=auto"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        // 創建和執行request
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if let urlError = error as? URLError {
                    return urlError
                } else if error is DecodingError {
                    return APIError.decodingError
                } else {
                    return APIError.responseError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
