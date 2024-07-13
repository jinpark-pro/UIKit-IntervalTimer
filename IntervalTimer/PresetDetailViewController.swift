//
//  PresetDetailViewController.swift
//  IntervalTimer
//
//  Created by Jungjin Park on 2024-07-14.
//

import UIKit

class PresetDetailViewController: UIViewController {
    var preset: [String: Any]
    
    init(preset: [String : Any]) {
        self.preset = preset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Timer", for: .normal)
        button.backgroundColor = .systemBrown
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.addTarget(self, action: #selector(startPreset), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Details"
        
        let initialWorkoutTime = preset["initialWorkoutTime"] as? Int ?? 0
        let totalRepeatWorkout = preset["totalRepeatWorkout"] as? Int ?? 0
        let initialRestTime = preset["initialRestTime"] as? Int ?? 0
        let totalRounds = preset["totalRounds"] as? Int ?? 0
        
        detailsLabel.text =
        """
        Name: \(preset["name"] as? String ?? "Preset")
        Workout Seconds: \(initialWorkoutTime)s
        Repeat Workout: \(totalRepeatWorkout)
        Rest Seconds: \(initialRestTime)s
        Rounds: \(totalRounds)
        """
        
        view.addSubview(detailsLabel)
        view.addSubview(startButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
            detailsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            startButton.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 60),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 100),
            startButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
        ])
    }

    @objc func startPreset() {
        let intervalTimerVC = IntervalTimerViewController(preset: preset)
        navigationController?.pushViewController(intervalTimerVC, animated: true)
    }
}
