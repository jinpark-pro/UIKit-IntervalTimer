//
//  ViewController.swift
//  IntervalTimer
//
//  Created by Jungjin Park on 2024-06-16.
//

import UIKit

class IntervalTimerViewController: UIViewController {
    var workoutTimer: Timer?
    var restTimer: Timer?
    let initialWorkoutTime = 5
    var workoutTime = 5
    var repeatWorkout = 0
    let totalRepeatWorkout = 3
    let initialRestTime = 5
    var restTime = 5
    var totalRounds = 3
    var currentRound = 1
    
    lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 40
        stackView.backgroundColor = .red
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var roundLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var secondsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .blue
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        startWorkoutTimer()
        
        view.backgroundColor = .white
        view.addSubview(container)
        container.addArrangedSubview(roundLabel)
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(secondsLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: safeArea.topAnchor),
            container.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            roundLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            roundLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            secondsLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            secondsLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            
        ])
    }

    func startWorkoutTimer() {
        self.repeatWorkout += 1
        self.roundLabel.text = "Round \(self.currentRound) / \(self.totalRounds)"
        self.titleLabel.text  = "Workout \(self.repeatWorkout) / \(self.totalRepeatWorkout)"
        self.secondsLabel.text = "\(self.workoutTime) seconds"
        workoutTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.workoutTime -= 1
            self.secondsLabel.text = "\(self.workoutTime) seconds"
            if self.workoutTime == 0 {
                self.workoutTimer?.invalidate()
                self.workoutTime = self.initialWorkoutTime
                if self.repeatWorkout == self.totalRepeatWorkout {
                    self.repeatWorkout = 0
                    self.startRestTimer()
                } else {
                    startWorkoutTimer()
                }
                
            }
        }
    }
    
    func startRestTimer() {
        self.titleLabel.text  = "Rest"
        self.secondsLabel.text = "\(self.restTime) seconds (Rest)"
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.restTime -= 1
            self.secondsLabel.text = "\(self.restTime) seconds (Rest)"
            if self.restTime == 0 {
                self.restTimer?.invalidate()
                self.restTime = self.initialRestTime
                self.currentRound += 1
                if self.currentRound <= self.totalRounds {
                    self.startWorkoutTimer()
                } else {
                    self.endWorkout()
                }
            }
        }
    }
    
    func endWorkout() {
        self.titleLabel.text  = "Finish"
        self.secondsLabel.text = nil
    }
}

