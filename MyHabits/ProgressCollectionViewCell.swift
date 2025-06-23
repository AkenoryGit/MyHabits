//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Дмитрий Дудник on 19.06.2025.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentLabel: UILabel!
    
    func configure() {
        titleLabel.text = "Прогресс дня"
        titleLabel.textColor = UIColor.gray
        
        percentLabel.textColor = UIColor.gray
        
        let progress = HabitsStore.shared.todayProgress
        progressView.setProgress(progress, animated: true)
        
        let percent = Int(progress * 100)
        percentLabel.text = "\(percent)%"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .white
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
}
