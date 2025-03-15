//
//  HourlyCell.swift
//  Weather
//
//  Created by Lydia Lu on 2025/3/14.
//

import UIKit

// 每小時預報Cell
class HourlyCell: UICollectionViewCell {
    private let timeLabel = UILabel()
    private let tempLabel = UILabel()
    private let precipLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 設定timeLabel
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textAlignment = .center
        contentView.addSubview(timeLabel)
        
        // 設定tempLabel
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        tempLabel.textAlignment = .center
        contentView.addSubview(tempLabel)
        
        // 設定precipLabel
        precipLabel.translatesAutoresizingMaskIntoConstraints = false
        precipLabel.font = UIFont.systemFont(ofSize: 12)
        precipLabel.textColor = .systemBlue
        precipLabel.textAlignment = .center
        contentView.addSubview(precipLabel)
        
        // 設定Auto Layout約束
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            tempLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            precipLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 8),
            precipLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            precipLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            precipLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
        
        // 設定背景和邊框
        contentView.backgroundColor = UIColor.systemGray6
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func configure(time: String, temperature: String, precipitation: String) {
        timeLabel.text = time
        tempLabel.text = temperature
        precipLabel.text = "降雨 \(precipitation)"
    }
}
