//
//  SettingsViewController.swift
//  IntervalTimer
//
//  Created by Jungjin Park on 2024-07-02.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    /*
     let initialWorkoutTime = 5
     let totalRepeatWorkout = 3
     let initialRestTime = 5
     let totalRounds = 3
     */
    lazy var tableView: UITableView = {
        let tableView =  UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let cellReuseIdentifier = "CustomTableViewCell"
    let cellWithButtonReuseIdentifier = "CustomTableViewCellWithButton"
    
    let titles = ["Workout Seconds", "Repeat Workout Times", "Rest Seconds", "Total Rounds"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.register(CustomTableViewCellWithButton.self, forCellReuseIdentifier: cellWithButtonReuseIdentifier)
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
        
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellWithButtonReuseIdentifier, for: indexPath) as! CustomTableViewCellWithButton
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomTableViewCell
            cell.titleLabel.text = titles[indexPath.row]
            cell.textField.placeholder = "Enter number here"
            cell.textField.delegate = self
            
            return cell
        }
    }
}
