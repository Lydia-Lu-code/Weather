//
//  Model.swift
//  Weather
//
//  Created by Lydia Lu on 2025/3/14.
//

import Foundation

// 完整的天氣回應模型
struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
}

// 目前天氣資料
struct CurrentWeather: Codable {
    let time: String
    let temperature2m: Double
    let relativeHumidity2m: Int
    let precipitation: Double
    let windSpeed10m: Double
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case relativeHumidity2m = "relative_humidity_2m"
        case precipitation
        case windSpeed10m = "wind_speed_10m"
    }
}

// 每小時天氣預報
struct HourlyWeather: Codable {
    let time: [String]
    let temperature2m: [Double]
    let precipitationProbability: [Int]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case precipitationProbability = "precipitation_probability"
    }
}

// 每日天氣預報
struct DailyWeather: Codable {
    let time: [String]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]
    let sunrise: [String]
    let sunset: [String]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
        case sunrise
        case sunset
    }
}
