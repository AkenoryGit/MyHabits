//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Дмитрий Дудник on 19.06.2025.
//

import UIKit

class HabitViewController: UIViewController {
    
    var selectedColor: UIColor = UIColor(named: "PurpleMain") ?? .blue
    var habitToEdit: Habit?
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        if habitToEdit != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty else { return }

        if let habit = habitToEdit {
            habit.name = name
            habit.date = datePicker.date
            habit.color = selectedColor
            NotificationCenter.default.post(name: .didCreateHabit, object: nil)
            navigationController?.popViewController(animated: true)
        } else {
            let newHabit = Habit(name: name, date: datePicker.date, color: selectedColor)
            HabitsStore.shared.habits.append(newHabit)
            NotificationCenter.default.post(name: .didCreateHabit, object: nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let habit = habitToEdit else { return }

        let alert = UIAlertController(
            title: "Удалить привычку?",
            message: "Это действие нельзя отменить.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { _ in
            if let index = HabitsStore.shared.habits.firstIndex(of: habit) {
                HabitsStore.shared.habits.remove(at: index)
                NotificationCenter.default.post(name: .didCreateHabit, object: nil)
            }

            self.navigationController?.popToRootViewController(animated: true)
        })

        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var colorButton: UIButton!
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Выберите цвет", message: nil, preferredStyle: .actionSheet)
        
        let colors: [(name: String, color: UIColor)] = [
            ("Фиолетовый", UIColor(named: "PurpleMain") ?? .purple),
            ("Синий", UIColor(named: "BlueHabit") ?? .systemBlue),
            ("Зелёный", UIColor(named: "GreenHabit") ?? .systemGreen),
            ("Оранжевый", UIColor(named: "OrangeHabit") ?? .systemOrange),
            ("Фиолетовый 2", UIColor(named: "PurpleSecondary") ?? .systemPurple),
        ]
        
        for (name, color) in colors {
            let action = UIAlertAction(title: name, style: .default) { [weak self] _ in
                self?.selectedColor = color
                self?.updateColorButton()
            }
            action.setValue(color, forKey: "titleTextColor")
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: sender.date)
        timeLabel.text = timeString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)

        deleteButton.isHidden = habitToEdit == nil
        
        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        
        let now = Date()
        datePicker.date = now

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: now)
        timeLabel.text = "\(timeString)"
        
        if let habitToEdit = habitToEdit {
            nameTextField.text = habitToEdit.name
            selectedColor = habitToEdit.color
            datePicker.date = habitToEdit.date
            updateColorButton()
        }
        
        if let habit = habitToEdit {
            nameTextField.text = habit.name
            datePicker.date = habit.date
            selectedColor = habit.color
            updateColorButton()
        }
        
        nameTextField.becomeFirstResponder()
        
        updateColorButton()
    }

    private func updateColorButton() {
        colorButton.backgroundColor = selectedColor
    }

}
