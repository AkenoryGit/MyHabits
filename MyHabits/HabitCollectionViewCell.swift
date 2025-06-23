//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Дмитрий Дудник on 19.06.2025.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    var onCheckmarkTapped: (() -> Void)?
    private var habit: Habit?
    private var habitIndex: Int?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    func configure(at index: Int) {
        let habit = HabitsStore.shared.habits[index]
        self.habitIndex = index
        self.habit = habit
        
        titleLabel.text = habit.name
        titleLabel.textColor = habit.color
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        timeLabel.text = habit.dateString
        timeLabel.textColor = .gray
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        counterLabel.text = "Счётчик: \(habit.trackDates.count)"
        counterLabel.textColor = .gray
        counterLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        let checkmarkImage = habit.isAlreadyTakenToday ? "checkmark.circle.fill" : "circle"
        checkmarkButton.setImage(UIImage(systemName: checkmarkImage), for: .normal)
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
        configure(at: index)
        
        onCheckmarkTapped?()
    }
}
