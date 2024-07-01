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
    
    var initailFontSize = 50
    
    var isPlay = false {
        didSet {
            if isPlay {
                startTimer()
                return
            }
            
            if isRest {
                pauseTimer(from: "rest")
            } else {
                pauseTimer(from: "workout")
            }
        }
    }
    var isWorkout = false
    var isRest = false
    
    lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // set padding
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    lazy var subContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var secondsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 320)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var roundLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var exerciseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .brown
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 80)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.isPlay.toggle()
            if self.isPlay {
                self.exerciseButton.setTitle("Pause", for: .normal)
            } else {
                self.exerciseButton.setTitle("Resume", for: .normal)
            }
        }, for: .touchUpInside)
        
        titleLabel.text = "Workout 0 / 0"
        secondsLabel.text = "0"
        roundLabel.text = "Round 0 / 0"
        
        view.backgroundColor = .white
        
        subContainer.addArrangedSubview(titleLabel)
        subContainer.addArrangedSubview(secondsLabel)
        subContainer.addArrangedSubview(roundLabel)
        container.addArrangedSubview(subContainer)
        container.addArrangedSubview(exerciseButton)
        
        view.addSubview(container)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: safeArea.topAnchor),
            container.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self, UITraitHorizontalSizeClass.self, UITraitVerticalSizeClass.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.updateStackViewAxis()
        }
        updateStackViewAxis()
    }
    
    func updateStackViewAxis() {
        if traitCollection.verticalSizeClass == .compact {
            container.axis = .horizontal
        } else {
            container.axis = .vertical
        }
    }
    
    func startTimer() {
        if isRest {
            startRestTimer()
        } else {
            startWorkoutTimer()
        }
    }
    
    func pauseTimer(from: String) {
        if from == "rest" {
            self.restTimer?.invalidate()
        } else {
            self.repeatWorkout -= 1
            self.workoutTimer?.invalidate()
        }
    }
    
    func startWorkoutTimer() {
        self.isWorkout = true
        self.repeatWorkout += 1
        self.roundLabel.text = "Round \(self.currentRound) / \(self.totalRounds)"
        self.titleLabel.text  = "Workout \(self.repeatWorkout) / \(self.totalRepeatWorkout)"
        self.secondsLabel.text = "\(self.workoutTime)"
        workoutTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.workoutTime -= 1
            self.secondsLabel.text = "\(self.workoutTime)"
            if self.workoutTime == 0 {
                self.workoutTimer?.invalidate()
                self.isWorkout = false
                self.workoutTime = self.initialWorkoutTime
                if self.repeatWorkout != self.totalRepeatWorkout {
                    startWorkoutTimer()
                    return
                }
                if self.currentRound == self.totalRounds {
                    endWorkout()
                } else {
                    self.repeatWorkout = 0
                    self.startRestTimer()
                }
            }
        }
    }
    
    func startRestTimer() {
        self.isRest = true
        self.titleLabel.text  = "Rest"
        self.secondsLabel.text = "\(self.restTime)"
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.restTime -= 1
            self.secondsLabel.text = "\(self.restTime)"
            if self.restTime == 0 {
                self.isRest = false
                self.restTimer?.invalidate()
                self.restTime = self.initialRestTime
                self.currentRound += 1
                if self.currentRound <= self.totalRounds {
                    self.startWorkoutTimer()
                }
            }
        }
    }
    
    func endWorkout() {
        self.titleLabel.text  = "Finish"
        self.secondsLabel.text = "0"
        self.exerciseButton.setTitle("Start", for: .normal)
        self.exerciseButton.backgroundColor = .brown
    }
}

#Preview {
    IntervalTimerViewController()
}
