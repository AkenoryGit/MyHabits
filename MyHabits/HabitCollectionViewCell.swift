//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Дмитрий Дудник on 19.06.2025.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    // MARK: - Properties

    var onCheckmarkTapped: (() -> Void)?
    private var habit: Habit?
    private var habitIndex: Int?
    
    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        habit = nil
        habitIndex = nil
        checkmarkButton.setImage(nil, for: .normal)
    }

    // MARK: - Configuration

    func configure(with habit: Habit, index: Int) {
        self.habit = habit
        self.habitIndex = index

        titleLabel.text = habit.name
        titleLabel.textColor = habit.color
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail

        timeLabel.text = habit.dateString
        timeLabel.textColor = .gray
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        counterLabel.text = "Счётчик: \(habit.trackDates.count)"
        counterLabel.textColor = .gray
        counterLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        let checkmarkImage = habit.isAlreadyTakenToday ? "checkmark.circle.fill" : "circle"
        let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .regular)
        let image = UIImage(systemName: checkmarkImage, withConfiguration: config)
        checkmarkButton.setImage(image, for: .normal)
        checkmarkButton.tintColor = habit.color

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    // MARK: - Actions

    /// Вызывается при нажатии на кнопку галочки
    @IBAction func checkmarkTapped(_ sender: UIButton) {
        guard let index = habitIndex else { return }

        let habit = HabitsStore.shared.habits[index]
        let today = Calendar.current.startOfDay(for: Date())

        if let i = habit.trackDates.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: today) }) {
            habit.trackDates.remove(at: i)
        } else {
            habit.trackDates.append(today)
        }

        HabitsStore.shared.save()
        configure(with: habit, index: index)
        onCheckmarkTapped?()
    }
}
