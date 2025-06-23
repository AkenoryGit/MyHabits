//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Дмитрий Дудник on 19.06.2025.
//

import UIKit

class HabitsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Сегодня"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = UIColor(named: "GrayBackground")
        collectionView.backgroundColor = UIColor(named: "GrayBackground")
        
        collectionView.dataSource = self
        collectionView.delegate = self

        if let tabBar = tabBarController?.tabBar {
            tabBar.backgroundColor = .systemBackground
            tabBar.layer.borderColor = UIColor.lightGray.cgColor
            tabBar.layer.borderWidth = 0.5
            tabBar.clipsToBounds = true
        }

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .systemBackground
        navBarAppearance.shadowColor = UIColor.lightGray
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .didCreateHabit, object: nil)
    }
        
    @objc private func reloadData() {
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let habitVC = storyboard.instantiateViewController(withIdentifier: "HabitViewController")

        let navController = UINavigationController(rootViewController: habitVC)
        present(navController, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + HabitsStore.shared.habits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32

        if indexPath.item == 0 {
            return CGSize(width: width, height: 70)
        } else {
            return CGSize(width: width, height: 130)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCollectionViewCell", for: indexPath) as! ProgressCollectionViewCell
            cell.configure()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCollectionViewCell", for: indexPath) as! HabitCollectionViewCell
            
            cell.onCheckmarkTapped = { [weak self] in
                self?.collectionView.reloadData()
            }

            cell.configure(at: indexPath.item - 1)

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != 0 else { return }
        
        let habit = HabitsStore.shared.habits[indexPath.item - 1]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "HabitDetailsViewController") as? HabitDetailsViewController {
            detailsVC.habit = habit
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowHabitDetails",
           let detailsVC = segue.destination as? HabitDetailsViewController,
           let indexPath = collectionView.indexPathsForSelectedItems?.first {
            
            let habit = HabitsStore.shared.habits[indexPath.item - 1]
            detailsVC.habit = habit
        }
    }
}

extension Notification.Name {
    static let didCreateHabit = Notification.Name("didCreateHabit")
}
