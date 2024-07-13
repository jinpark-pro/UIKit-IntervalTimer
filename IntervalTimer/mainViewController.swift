//
//  mainViewController.swift
//  IntervalTimer
//
//  Created by Jungjin Park on 2024-07-14.
//

import UIKit

class mainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var listOfPresets = [
        [
            "name": "Test",
            "initialWorkoutTime": 5,
            "totalRepeatWorkout": 3,
            "initialRestTime": 5,
            "totalRounds": 3
        ],
        [
            "name": "Mountain Climber",
            "initialWorkoutTime": 8,
            "totalRepeatWorkout": 10,
            "initialRestTime": 32,
            "totalRounds": 10
        ],
    ]
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Interval Timer"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToSettings))
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    @objc func goToSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .pageSheet
        if let sheet = settingsVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(settingsVC, animated: true, completion: nil)
    }
    
    // MARK: - UITabelViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfPresets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let preset = listOfPresets[indexPath.row]
        let name = preset["name"] as? String ?? "Preset"
        let totalRepeatWorkout = preset["totalRepeatWorkout"] as? Int ?? 0
        let totalRounds = preset["totalRounds"] as? Int ?? 0
        
        cell.textLabel?.text = "\(name) - Workout: \(totalRepeatWorkout) x \(totalRounds) Sets"
        
        return cell
    }
}
