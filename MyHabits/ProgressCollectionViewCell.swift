//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Дмитрий Дудник on 19.06.2025.
//

import UIKit

final class ProgressCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var percentLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

    // MARK: - Public Methods

    func configure() {
        let progress = HabitsStore.shared.todayProgress
        let percent = Int(progress * 100)

        titleLabel.text = "Прогресс дня"
        titleLabel.textColor = .gray

        percentLabel.text = "\(percent)%"
        percentLabel.textColor = .gray

        progressView.setProgress(progress, animated: true)
    }

    // MARK: - Private Methods

    private func configureAppearance() {
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
