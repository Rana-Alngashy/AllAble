//
//  TimerViewModel.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//
// TimerViewModel.swift
import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
    @Published var timeRemaining: Int = 1 // Set to 1 second for fast testing
    @Published var isActive = false
    @Published var isFinished: Bool = false
    
    private var timer: AnyCancellable?

    func start() {
        if isActive { return }
        
        if timeRemaining <= 0 {
            timeRemaining = 1
            isFinished = false
        }
        
        isActive = true
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.stop()
                    self.isFinished = true
                }
            }
    }
    
    func stop() {
        isActive = false
        timer?.cancel()
        timer = nil
    }
    
    var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    deinit {
        timer?.cancel()
    }
}
