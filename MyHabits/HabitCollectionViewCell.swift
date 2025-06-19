//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Дмитрий Дудник on 19.06.2025.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    func configure() {
        titleLabel.text = "Выпить стакан воды"
        titleLabel.textColor = UIColor.systemBlue
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        timeLabel.text = "Каждый день в 7:30"
        timeLabel.textColor = .gray
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        counterLabel.text = "Счётчик: 0"
        counterLabel.textColor = .gray
        counterLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        checkmarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkmarkButton.tintColor = UIColor.systemBlue
    }
}
