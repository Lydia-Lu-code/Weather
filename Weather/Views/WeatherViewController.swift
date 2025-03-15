//
//  ViewController.swift
//  Weather
//
//  Created by Lydia Lu on 2025/3/14.
//

import UIKit
import Combine

class WeatherViewController: UIViewController {
    // UI元素
    private let temperatureLabel = UILabel()
    private let humidityLabel = UILabel()
    private let windSpeedLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()
    private let forecastTableView = UITableView()
    
    private let viewModel = WeatherViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let locationLabel = UILabel()
    private let timezoneLabel = UILabel()
    private let currentTimeLabel = UILabel()
    private let hourlyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let dailyTableView = UITableView(frame: .zero, style: .plain)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
        // 使用台北的座標作為範例
        viewModel.fetchWeather(latitude: 25.0330, longitude: 121.5654)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "詳細天氣資料"
        
        // 設定scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 設定locationLabel
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.textColor = .darkGray
        locationLabel.textAlignment = .center
        contentView.addSubview(locationLabel)
        
        // 設定timezoneLabel
        timezoneLabel.translatesAutoresizingMaskIntoConstraints = false
        timezoneLabel.font = UIFont.systemFont(ofSize: 14)
        timezoneLabel.textColor = .darkGray
        timezoneLabel.textAlignment = .center
        contentView.addSubview(timezoneLabel)
        
        // 設定currentTimeLabel
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.font = UIFont.systemFont(ofSize: 14)
        currentTimeLabel.textColor = .darkGray
        currentTimeLabel.textAlignment = .center
        contentView.addSubview(currentTimeLabel)
        
        // 設定temperatureLabel
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 42, weight: .light)
        temperatureLabel.textAlignment = .center
        contentView.addSubview(temperatureLabel)
        
        // 設定humidityLabel
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(humidityLabel)
        
        // 設定windSpeedLabel
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(windSpeedLabel)
        
        // 設定每小時預報區段標題
        let hourlyTitleLabel = UILabel()
        hourlyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        hourlyTitleLabel.text = "每小時預報"
        hourlyTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        contentView.addSubview(hourlyTitleLabel)
        
        // 設定hourlyCollectionView
        let hourlyLayout = UICollectionViewFlowLayout()
        hourlyLayout.scrollDirection = .horizontal
        hourlyLayout.itemSize = CGSize(width: 80, height: 100)
        hourlyLayout.minimumLineSpacing = 10
        
        hourlyCollectionView.collectionViewLayout = hourlyLayout
        hourlyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        hourlyCollectionView.backgroundColor = .clear
        hourlyCollectionView.showsHorizontalScrollIndicator = false
        hourlyCollectionView.register(HourlyCell.self, forCellWithReuseIdentifier: "HourlyCell")
        hourlyCollectionView.dataSource = self
        contentView.addSubview(hourlyCollectionView)
        
        // 設定每日預報區段標題
        let dailyTitleLabel = UILabel()
        dailyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyTitleLabel.text = "7日預報"
        dailyTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        contentView.addSubview(dailyTitleLabel)
        
        // 設定dailyTableView
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
        dailyTableView.backgroundColor = .clear
        dailyTableView.isScrollEnabled = false
        dailyTableView.register(DailyForecastCell.self, forCellReuseIdentifier: "DailyCell")
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        contentView.addSubview(dailyTableView)
        
        // 設定loadingIndicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        
        // 設定errorLabel
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        view.addSubview(errorLabel)
        
        // 設定Auto Layout約束
        NSLayoutConstraint.activate([
            // scrollView約束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // contentView約束
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // locationLabel約束
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // timezoneLabel約束
            timezoneLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            timezoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timezoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // currentTimeLabel約束
            currentTimeLabel.topAnchor.constraint(equalTo: timezoneLabel.bottomAnchor, constant: 4),
            currentTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currentTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // temperatureLabel約束
            temperatureLabel.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: 16),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // humidityLabel約束
            humidityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 16),
            humidityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            // windSpeedLabel約束
            windSpeedLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 16),
            windSpeedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // hourlyTitleLabel約束
            hourlyTitleLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 24),
            hourlyTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // hourlyCollectionView約束
            hourlyCollectionView.topAnchor.constraint(equalTo: hourlyTitleLabel.bottomAnchor, constant: 8),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: 120),
            
            // dailyTitleLabel約束
            dailyTitleLabel.topAnchor.constraint(equalTo: hourlyCollectionView.bottomAnchor, constant: 24),
            dailyTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // dailyTableView約束
            dailyTableView.topAnchor.constraint(equalTo: dailyTitleLabel.bottomAnchor, constant: 8),
            dailyTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dailyTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dailyTableView.heightAnchor.constraint(equalToConstant: 350),
            dailyTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // loadingIndicator約束
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // errorLabel約束
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupBindings() {
        // 綁定溫度
        viewModel.$currentTemperature
            .sink { [weak self] temperature in
                self?.temperatureLabel.text = temperature
            }
            .store(in: &cancellables)
        
        // 綁定濕度
        viewModel.$humidity
            .sink { [weak self] humidity in
                self?.humidityLabel.text = "濕度: \(humidity)"
            }
            .store(in: &cancellables)
        
        // 綁定風速
        viewModel.$windSpeed
            .sink { [weak self] windSpeed in
                self?.windSpeedLabel.text = "風速: \(windSpeed)"
            }
            .store(in: &cancellables)
        
        // 綁定位置
        viewModel.$location
            .sink { [weak self] location in
                self?.locationLabel.text = location
            }
            .store(in: &cancellables)
        
        // 綁定時區
        viewModel.$timezone
            .sink { [weak self] timezone in
                self?.timezoneLabel.text = "時區: \(timezone)"
            }
            .store(in: &cancellables)
        
        // 綁定目前時間
        viewModel.$currentTime
            .sink { [weak self] time in
                self?.currentTimeLabel.text = "更新時間: \(time)"
            }
            .store(in: &cancellables)
        
        // 綁定加載狀態
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
                self?.loadingIndicator.isHidden = !isLoading
            }
            .store(in: &cancellables)
        
        // 綁定錯誤訊息
        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                self?.errorLabel.text = errorMessage
                self?.errorLabel.isHidden = errorMessage == nil
            }
            .store(in: &cancellables)
        
        // 綁定每小時預報資料
        viewModel.$hourlyForecast
            .sink { [weak self] _ in
                self?.hourlyCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // 綁定每日預報資料
        viewModel.$dailyForecast
            .sink { [weak self] _ in
                self?.dailyTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
}

// 為每小時預報建立UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(24, viewModel.hourlyForecast.count) // 只顯示24小時
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as? HourlyCell else {
            return UICollectionViewCell()
        }
        
        let hourForecast = viewModel.hourlyForecast[indexPath.item]
        
        // 格式化時間
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: hourForecast.time)
        
        cell.configure(
            time: timeString,
            temperature: "\(hourForecast.temperature)°C",
            precipitation: "\(hourForecast.precipitationProbability)%"
        )
        
        return cell
    }
}

// 為每日預報擴展TableView的DataSource和Delegate
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as? DailyForecastCell else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DefaultCell")
            return cell
        }
        
        let forecast = viewModel.dailyForecast[indexPath.row]
        
        // 設定日期格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd EEEE"
        dateFormatter.locale = Locale(identifier: "zh_TW")
        let dateString = dateFormatter.string(from: forecast.date)
        
        cell.configure(
            date: dateString,
            maxTemp: "\(forecast.maxTemperature)°C",
            minTemp: "\(forecast.minTemperature)°C",
            sunrise: forecast.sunrise,
            sunset: forecast.sunset
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


