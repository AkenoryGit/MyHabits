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
    
    func configure() {
        titleLabel.text = "Прогресс дня"
    }
}
