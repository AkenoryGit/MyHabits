//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Дмитрий Дудник on 19.06.2025.
//

import UIKit

final class HabitViewController: UIViewController {

    // MARK: - Public Properties

    var selectedColor: UIColor = UIColor(named: "PurpleMain") ?? .blue
    var habitToEdit: Habit?

    // MARK: - Outlets

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGestureToHideKeyboard()
        configureUI()
        configureViewForHabit()
    }

    // MARK: - Setup

    private func setupGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground

        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray.cgColor

        deleteButton.isHidden = habitToEdit == nil
    }

    private func configureViewForHabit() {
        if let habit = habitToEdit {
            navigationItem.title = "Править"
            nameTextField.text = habit.name
            datePicker.date = habit.date
            selectedColor = habit.color
        } else {
            navigationItem.title = "Создать"
            datePicker.date = Date()
            nameTextField.becomeFirstResponder()
        }

        updateTimeLabel()
        updateColorButton()

    }

    private func updateTimeLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: datePicker.date)
    }

    private func updateColorButton() {
        colorButton.backgroundColor = selectedColor
    }

    // MARK: - Actions

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
            message: "Вы хотите удалить привычку «\(habit.name)»?",
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

    @IBAction func colorButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Выберите цвет", message: nil, preferredStyle: .actionSheet)

        let colors: [(name: String, color: UIColor)] = [
            ("Фиолетовый", UIColor(named: "PurpleMain") ?? .purple),
            ("Синий", UIColor(named: "BlueHabit") ?? .systemBlue),
            ("Зелёный", UIColor(named: "GreenHabit") ?? .systemGreen),
            ("Оранжевый", UIColor(named: "OrangeHabit") ?? .systemOrange),
            ("Фиолетовый 2", UIColor(named: "PurpleSecondary") ?? .systemPurple)
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

        if let popover = alert.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.permittedArrowDirections = .any
        }

        present(alert, animated: true, completion: nil)
    }

    @IBAction func dateChanged(_ sender: UIDatePicker) {
        updateTimeLabel()
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
