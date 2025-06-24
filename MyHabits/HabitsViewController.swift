//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Дмитрий Дудник on 19.06.2025.
//

import UIKit

final class HabitsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTabBar()
        setupCollectionView()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .didCreateHabit, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationItem.title = "Сегодня"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = UIColor.lightGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func setupTabBar() {
        if let tabBar = tabBarController?.tabBar {
            tabBar.backgroundColor = .systemBackground
            tabBar.layer.borderColor = UIColor.lightGray.cgColor
            tabBar.layer.borderWidth = 0.5
            tabBar.clipsToBounds = true
        }
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "GrayBackground")
        view.backgroundColor = UIColor(named: "GrayBackground")
    }

    // MARK: - Actions

    @IBAction func addButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let habitVC = storyboard.instantiateViewController(withIdentifier: "HabitViewController")
        let navController = UINavigationController(rootViewController: habitVC)
        present(navController, animated: true, completion: nil)
    }

    // MARK: - Helpers

    @objc private func reloadData() {
        collectionView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowHabitDetails",
           let detailsVC = segue.destination as? HabitDetailsViewController,
           let indexPath = collectionView.indexPathsForSelectedItems?.first {
            let habit = HabitsStore.shared.habits[indexPath.item - 1]
            detailsVC.habit = habit
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HabitsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + HabitsStore.shared.habits.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCollectionViewCell", for: indexPath) as! ProgressCollectionViewCell
            cell.configure()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCollectionViewCell", for: indexPath) as! HabitCollectionViewCell
            let habit = HabitsStore.shared.habits[indexPath.item - 1]
            cell.configure(with: habit, index: indexPath.item - 1)

            cell.onCheckmarkTapped = { [weak self] in
                self?.collectionView.reloadData()
            }

            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HabitsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != 0 else { return }

        let habit = HabitsStore.shared.habits[indexPath.item - 1]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "HabitDetailsViewController") as? HabitDetailsViewController {
            detailsVC.habit = habit
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return indexPath.item == 0
            ? CGSize(width: width, height: 70)
            : CGSize(width: width, height: 130)
    }
}

// MARK: - Notification

extension Notification.Name {
    static let didCreateHabit = Notification.Name("didCreateHabit")
}
