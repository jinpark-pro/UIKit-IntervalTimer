//
//  mainViewController.swift
//  IntervalTimer
//
//  Created by Jungjin Park on 2024-07-14.
//

import UIKit

class PresetListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SettingsViewControllerDelegate {
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
        navigationItem.title = "Interval Timer (Presets)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToSettings))
        navigationItem.leftBarButtonItem = self.editButtonItem
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: animated)
    }
    
    // MARK: Methods
    @objc func goToSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.delegate = self
        settingsVC.modalPresentationStyle = .fullScreen
        present(settingsVC, animated: true, completion: nil)
    }
    
    // MARK: - SettingsViewControllerDelegate
    func didAddPreset(_ preset: [String : Any]) {
        print("preset: \(preset)")
        listOfPresets.append(preset)
        tableView.reloadData()
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
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let preset = listOfPresets[indexPath.row]
        let detailVC = PresetDetailViewController(preset: preset)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listOfPresets.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
