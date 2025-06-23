//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Дмитрий Дудник on 23.06.2025.
//

import UIKit

class HabitDetailsViewController: UIViewController, UITableViewDataSource {

    var habit: Habit!

    @IBOutlet weak var tableView: UITableView!
    
    @objc private func editHabit() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editVC = storyboard.instantiateViewController(withIdentifier: "HabitViewController") as? HabitViewController {
            editVC.habitToEdit = habit
            editVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(editVC, animated: true)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editHabit))
        
        title = habit.name
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath)
        
        let index = HabitsStore.shared.dates.count - 1 - indexPath.row
        let date = HabitsStore.shared.dates[index]

        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: index)
        
        let isTracked = HabitsStore.shared.habit(habit, isTrackedIn: date)
        cell.accessoryType = isTracked ? .checkmark : .none

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 { return }

        let habit = HabitsStore.shared.habits[indexPath.item - 1]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "HabitDetailsViewController") as! HabitDetailsViewController
        detailsVC.habit = habit

        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
