//
//  ViewModel.swift
//  Weather
//
//  Created by Lydia Lu on 2025/3/14.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    // 發布的屬性 - 會自動觸發UI更新
    @Published var currentTemperature: String = "--"
    @Published var humidity: String = "--"
    @Published var windSpeed: String = "--"
    @Published var dailyForecast: [DailyForecastItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var weatherResponse: WeatherResponse?
    @Published var hourlyForecast: [HourlyForecastItem] = []
    @Published var location: String = "--"
    @Published var timezone: String = "--"
    @Published var currentTime: String = "--"
    
    private let weatherService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = LocationManager()
    
    // 獲取指定位置的天氣資料
    func fetchWeather(latitude: Double, longitude: Double) {
        isLoading = true
        errorMessage = nil
        
        weatherService.getWeather(latitude: latitude, longitude: longitude)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = "無法載入天氣資料: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] response in
                self?.updateWeatherData(with: response)
            }
            .store(in: &cancellables)
    }
    
    private func updateWeatherData(with response: WeatherResponse) {
        // 保存完整回應
        self.weatherResponse = response
        
        // 更新位置和時區
        location = "經度: \(response.longitude), 緯度: \(response.latitude)"
        timezone = response.timezone
        
        // 更新目前天氣資料
        currentTemperature = "\(response.current.temperature2m)°C"
        humidity = "\(response.current.relativeHumidity2m)%"
        windSpeed = "\(response.current.windSpeed10m) km/h"
        currentTime = formatTime(response.current.time)
        
        // 更新每小時預報
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        hourlyForecast = zip(response.hourly.time, zip(response.hourly.temperature2m, response.hourly.precipitationProbability)).map { time, data in
            let (temp, precipProb) = data
            return HourlyForecastItem(
                time: hourFormatter.date(from: time) ?? Date(),
                temperature: temp,
                precipitationProbability: precipProb
            )
        }
        
        // 更新每日預報
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dailyForecast = zip(response.daily.time, zip(zip(response.daily.temperature2mMax, response.daily.temperature2mMin), zip(response.daily.sunrise, response.daily.sunset))).map { date, data in
            let ((maxTemp, minTemp), (sunrise, sunset)) = data
            return DailyForecastItem(
                date: dateFormatter.date(from: date) ?? Date(),
                maxTemperature: maxTemp,
                minTemperature: minTemp,
                sunrise: formatTime(sunrise),
                sunset: formatTime(sunset)
            )
        }
    }
    
    // 輔助方法：格式化時間
    private func formatTime(_ timeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        if let date = inputFormatter.date(from: timeString) {
            return outputFormatter.string(from: date)
        }
        return timeString
    }
    
    
    func startLocationBasedWeatherUpdates() {
        locationManager.locationPublisher
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = "位置錯誤: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] location in
                self?.fetchWeather(latitude: location.coordinate.latitude,
                                   longitude: location.coordinate.longitude)
            }
            .store(in: &cancellables)
        
        locationManager.requestLocation()
    }
    
}

struct HourlyForecastItem: Identifiable {
    let id = UUID()
    let time: Date
    let temperature: Double
    let precipitationProbability: Int
}

struct DailyForecastItem: Identifiable {
    let id = UUID()
    let date: Date
    let maxTemperature: Double
    let minTemperature: Double
    let sunrise: String
    let sunset: String
}


