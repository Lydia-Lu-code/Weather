//
//  DailyForecastCell.swift
//  Weather
//
//  Created by Lydia Lu on 2025/3/14.
//

import UIKit

// 每日預報Cell
class DailyForecastCell: UITableViewCell {
    private let dateLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let sunInfoLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 設定dateLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(dateLabel)
        
        // 設定temperatureLabel
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 16)
        temperatureLabel.textAlignment = .right
        contentView.addSubview(temperatureLabel)
        
        // 設定sunInfoLabel
        sunInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        sunInfoLabel.font = UIFont.systemFont(ofSize: 12)
        sunInfoLabel.textColor = .darkGray
        contentView.addSubview(sunInfoLabel)
        
        // 設定Auto Layout約束
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            
            sunInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sunInfoLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            sunInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(date: String, maxTemp: String, minTemp: String, sunrise: String, sunset: String) {
        dateLabel.text = date
        temperatureLabel.text = "\(maxTemp) / \(minTemp)"
        sunInfoLabel.text = "日出: \(sunrise), 日落: \(sunset)"
    }
}
