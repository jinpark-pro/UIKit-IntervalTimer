//
//  ViewController.swift
//  IntervalTimer
//
//  Created by Jungjin Park on 2024-06-16.
//

import UIKit
import AVFoundation

class IntervalTimerViewController: UIViewController {
    var preset: [String: Any]
    
    init(preset: [String : Any]) {
        self.preset = preset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.preset = [:]
        super.init(coder: coder)
    }
    
    var workoutTimer: Timer?
    var restTimer: Timer?
    var initialWorkoutTime = 5
    var workoutTime = 5
    var totalRepeatWorkout = 3
    var initialRestTime = 5
    var restTime = 5
    var totalRounds = 3
    
    var repeatWorkout = 1
    var currentRound = 1
    
    var isPlay = false {
        didSet {
            if isPlay {
                startTimer()
            } else {
                pauseTimer()
            }
        }
    }
    var isWorkout = false
    var isRest = false
    
    var audioPlayer1: AVAudioPlayer?
    var audioPlayer2: AVAudioPlayer?
    
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
        label.textColor = .label
        return label
    }()
    lazy var secondsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 320)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    lazy var roundLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    lazy var exerciseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .systemBrown
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 80)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialWorkoutTime = preset["initialWorkoutTime"] as! Int
        workoutTime = initialWorkoutTime
        totalRepeatWorkout = preset["totalRepeatWorkout"] as! Int
        initialRestTime = preset["initialRestTime"] as! Int
        restTime = initialRestTime
        totalRounds = preset["totalRounds"] as! Int

        navigationItem.title = preset["name"] as? String
        
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
        
        view.backgroundColor = .systemBackground
        
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
        
        prepareBeepSound()
    }
    
    // MARK: - Methods
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
    
    func pauseTimer() {
        if isRest {
            self.restTimer?.invalidate()
        } else {
            self.workoutTimer?.invalidate()
        }
    }
    
    func startWorkoutTimer() {
        self.isWorkout = true
        
        self.titleLabel.text  = "Workout \(self.repeatWorkout) / \(self.totalRepeatWorkout)"
        self.secondsLabel.text = "\(self.workoutTime)"
        self.roundLabel.text = "Round \(self.currentRound) / \(self.totalRounds)"
        
        playBeepSound()
        
        workoutTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.workoutTime -= 1
            self.secondsLabel.text = "\(self.workoutTime)"
            if self.workoutTime == 0 {
                self.workoutTimer?.invalidate()
                self.isWorkout = false
                self.workoutTime = self.initialWorkoutTime
                if self.repeatWorkout != self.totalRepeatWorkout {
                    self.repeatWorkout += 1
                    startWorkoutTimer()
                    return
                }
                if self.currentRound == self.totalRounds {
                    endWorkout()
                } else {
                    self.repeatWorkout = 1
                    self.startRestTimer()
                    playBeepEndSound()
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
            if self.restTime < 4 {
                playBeepSound()
            }
            if self.restTime == 0 {
                self.isRest = false
                self.restTimer?.invalidate()
                self.restTime = self.initialRestTime
                self.currentRound += 1
                if self.currentRound <= self.totalRounds {
                    self.startWorkoutTimer()
                    playBeepEndSound()
                }
            }
        }
    }
    
    func endWorkout() {
        self.titleLabel.text  = "Finish"
        self.secondsLabel.text = "0"
        self.exerciseButton.setTitle("Start", for: .normal)
        self.exerciseButton.backgroundColor = .brown
        // initialize
        self.repeatWorkout = 1
        self.currentRound = 1
        self.isPlay = false
        self.isRest = false
        self.isWorkout = false
    }
    
    func prepareBeepSound() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            if let beepSoundURL = Bundle.main.url(forResource: "beep", withExtension: "wav"),
               let beepEndSoundURL = Bundle.main.url(forResource: "beep-end", withExtension: "wav")
            {
                audioPlayer1 = try AVAudioPlayer(contentsOf: beepSoundURL)
                audioPlayer2 = try AVAudioPlayer(contentsOf: beepEndSoundURL)
                audioPlayer1?.prepareToPlay()
                audioPlayer2?.prepareToPlay()
            } else {
                print("Beep sound file not found")
            }
        } catch {
            print("Failed to set up AVAudioSession or load beep sound")
        }
    }
    
    func playBeepSound() {
        if let player = audioPlayer1 {
            if player.isPlaying {
                player.stop()
            }
            player.play()
        } else {
            print("Audio player1 is not initialized")
        }
    }
    
    func playBeepEndSound() {
        if let player = audioPlayer2 {
            if player.isPlaying {
                player.stop()
            }
            player.play()
        } else {
            print("Audio player2 is not initialized")
        }
    }
}

#Preview {
    IntervalTimerViewController(preset: [
        "name": "Mountain Climber",
        "initialWorkoutTime": 8,
        "totalRepeatWorkout": 10,
        "initialRestTime": 32,
        "totalRounds": 10
    ])
}
