//
//  SettingsViewController.swift
//  IntervalTimer
//
//  Created by Jungjin Park on 2024-07-02.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func didAddPreset(_ preset: [String: Any])
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    lazy var tableView: UITableView = {
        let tableView =  UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    let cellReuseIdentifier = "CustomTableViewCell"
    let cellWithButtonReuseIdentifier = "CustomTableViewCellWithButton"
    
    let titles = ["Name", "Workout Seconds", "Repeat Workout Times", "Rest Seconds", "Total Rounds", ""]
    
    var newPreset: [String: Any] = [:]
    weak var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAdd))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.register(CustomTableViewCellWithButton.self, forCellReuseIdentifier: cellWithButtonReuseIdentifier)
        
        view.backgroundColor = .systemBackground
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
            cell.button.addTarget(self, action: #selector(savePreset), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomTableViewCell
            cell.titleLabel.text = titles[indexPath.row]
            if indexPath.row == 0 {
                cell.textField.placeholder = "Enter Preset Title"
                cell.textField.keyboardType = .default
            } else {
                cell.textField.placeholder = "Enter Number Here"
            }
            cell.textField.delegate = self
            cell.textField.tag = indexPath.row
            
            return cell
        }
    }
    
    // MARK - UITextFieldDelegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        guard let value = Int(text) else {
            newPreset["name"] = text
            return
        }
        
        switch textField.tag {
        case 1: newPreset["initialWorkoutTime"] = value
        case 2: newPreset["totalRepeatWorkout"] = value
        case 3: newPreset["initialRestTime"] = value
        case 4: newPreset["totalRounds"] = value
        default: break
        }
    }
    
    // MARK: - Methods
    @objc func savePreset() {
        print("save preset: \(newPreset)")
        delegate?.didAddPreset(newPreset)
        dismiss(animated: true)
    }
    
    @objc func cancelAdd() {
        dismiss(animated: true)
    }
}
