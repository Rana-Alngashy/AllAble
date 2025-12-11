//
//  TimerView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
    
    // MARK: - Dependencies
    @EnvironmentObject var historyStore: HistoryStore
    @Environment(\.scenePhase) var scenePhase
    
    // MARK: - Incoming Data
    var mealType: String = "Snack"
    var mealName: String = "Meal"
    var carbs: Double = 0.0
    var dose: Double = 0.0
    
    // MARK: - State Properties
    @State private var selectedHours = 0
    @State private var selectedMinutes = 15
    @State private var selectedSeconds = 0  // Added Seconds
    
    @State private var timeRemaining: TimeInterval = 0
    @State private var totalTime: TimeInterval = 0
    
    // Persistence
    @AppStorage("timerEndTime") private var timerEndTime: Double = 0.0
    @AppStorage("isTimerActive") private var isTimerActive: Bool = false
    @AppStorage("savedTotalTime") private var savedTotalTime: Double = 0.0
    
    @State private var timer: Timer? = nil
    @State private var navigateToCongratsView = false
    
    // MARK: - Design Constants
    let timerCircleColor = Color(red: 0.60, green: 0.82, blue: 0.80)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)

    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { true }
    private var circleSize: CGFloat { isCompact ? 240 : 300 }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                customBackground.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // ————— TITLE —————
                    Text(isTimerActive ? "Title.TimerRunning" : "Set Timer")
                        .font(isCompact ? .title2 : .largeTitle)
                        .bold()
                        .padding(.top, isCompact ? 20 : 40)
                    
                    Spacer()
                    
                    // ————— CENTER CONTENT —————
                    ZStack {
                        if isTimerActive {
                            // 1. RUNNING STATE: Progress Circle
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                                    .frame(width: circleSize, height: circleSize)
                                
                                Circle()
                                    .trim(from: 0, to: totalTime > 0 ? CGFloat(timeRemaining / totalTime) : 0)
                                    .stroke(timerCircleColor, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                                    .frame(width: circleSize, height: circleSize)
                                    .animation(.linear(duration: 1.0), value: timeRemaining)
                                
                                Text(formatTime(timeRemaining))
                                    .font(.system(size: isCompact ? 48 : 60, weight: .bold, design: .monospaced))
                                    .foregroundColor(.primary)
                            }
                        } else {
                            // 2. SETUP STATE: 3-Column Picker (Hours | Minutes | Seconds)
                            HStack(spacing: 0) {
                                // Hours
                                Picker("Hours", selection: $selectedHours) {
                                    ForEach(0..<24) { i in
                                        Text("\(i) h").tag(i)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 80)
                                .clipped()
                                
                                // Minutes
                                Picker("Minutes", selection: $selectedMinutes) {
                                    ForEach(0..<60) { i in
                                        Text("\(i) m").tag(i)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 80)
                                .clipped()
                                
                                // Seconds
                                Picker("Seconds", selection: $selectedSeconds) {
                                    ForEach(0..<60) { i in
                                        Text("\(i) s").tag(i)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 80)
                                .clipped()
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.05), radius: 5)
                            )
                        }
                    }
                    
                    Spacer()
                    
                    // ————— ACTION BUTTONS —————
                    if isTimerActive {
                        Button(action: cancelTimer) {
                            Text("Cancel")
                                .font(.title3.bold())
                                .foregroundColor(.red)
                                .frame(maxWidth: 200)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.red, lineWidth: 1)
                                )
                        }
                    } else {
                        Button(action: startTimer) {
                            Text("Start Timer")
                                .font(.title3.bold())
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(isZeroTime() ? Color.gray.opacity(0.3) : customYellow)
                                .cornerRadius(14)
                        }
                        .disabled(isZeroTime())
                        .padding(.horizontal, 30)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            checkForExistingTimer()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                updateTimerState()
            }
        }
        .navigationDestination(isPresented: $navigateToCongratsView) {
            CongratsView(avatarType: "female")
        }
    }
    
    // MARK: - Logic
    
    func isZeroTime() -> Bool {
        return selectedHours == 0 && selectedMinutes == 0 && selectedSeconds == 0
    }
    
    func checkForExistingTimer() {
        if isTimerActive && timerEndTime > Date().timeIntervalSince1970 {
            self.totalTime = savedTotalTime
            updateTimerState()
            startLocalTimerLoop()
        } else if isTimerActive {
            finishTimer()
        }
    }
    
    func startTimer() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        
        // Calculate total seconds from H, M, and S
        let totalSeconds = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
        
        if totalSeconds > 0 {
            let now = Date()
            let endDate = now.addingTimeInterval(TimeInterval(totalSeconds))
            
            self.totalTime = TimeInterval(totalSeconds)
            self.savedTotalTime = self.totalTime
            self.timerEndTime = endDate.timeIntervalSince1970
            self.isTimerActive = true
            
            scheduleNotification(at: totalSeconds)
            updateTimerState()
            startLocalTimerLoop()
        }
    }
    
    func startLocalTimerLoop() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            updateTimerState()
        }
    }
    
    func updateTimerState() {
        guard isTimerActive else { return }
        
        let now = Date()
        let end = Date(timeIntervalSince1970: timerEndTime)
        let remaining = end.timeIntervalSince(now)
        
        if remaining <= 0 {
            finishTimer()
        } else {
            self.timeRemaining = remaining
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        isTimerActive = false
        timerEndTime = 0.0
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TimerFinished"])
    }
    
    func finishTimer() {
        timer?.invalidate()
        timer = nil
        
        if isTimerActive {
            isTimerActive = false
            timerEndTime = 0.0
            
            let entry = HistoryEntry(
                mealTypeTitle: mealType,
                mealName: mealName,
                totalCarbs: carbs,
                insulinDose: dose
            )
            historyStore.addEntry(entry)
            print("Timer Finished: Saved to history.")
            
            navigateToCongratsView = true
        }
    }
    
    // MARK: - Notification Helpers
    
    func scheduleNotification(at seconds: Int) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Notification.TimerDoneTitle", value: "Time's up!", comment: "")
        content.body = NSLocalizedString("Notification.TimerDoneBody", value: "Your wait time is over. Tap to continue.", comment: "")
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        let request = UNNotificationRequest(identifier: "TimerFinished", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func formatTime(_ totalSeconds: TimeInterval) -> String {
        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60
        let seconds = Int(totalSeconds) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

#Preview {
    TimerView()
        .environmentObject(HistoryStore())
}
