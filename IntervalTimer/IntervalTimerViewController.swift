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
    let initialWorkoutTIme = 5
    var workoutTime = 5
    let initialRestTime = 5
    var restTime = 5
    var totalRounds = 3
    var currentRound = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        startWorkoutTimer()
    }

    func startWorkoutTimer() {
        print("Round \(self.currentRound)")
        print("\(self.workoutTime) seconds")
        workoutTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.workoutTime -= 1
            print("\(self.workoutTime) seconds")
            if self.workoutTime == 0 {
                self.workoutTimer?.invalidate()
                self.workoutTime = self.initialWorkoutTIme
                self.startRestTimer()
            }
        }
    }
    
    func startRestTimer() {
        print("\(self.restTime) seconds (Rest)")
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.restTime -= 1
            print("\(self.restTime) seconds (Rest)")
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
        print("Workout End")
    }
}

