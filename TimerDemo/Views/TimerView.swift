//
//  TimerVeiw.swift
//  TimerDemo
//
//  Created by 최시온 on 1/24/25.
//

import SwiftUI
import AVFoundation
import UserNotifications

import SwiftUI
import AVFoundation
import UserNotifications

struct TimerView: View {
    @State private var timeRemaining: Int
    @State private var timer: Timer? = nil
    @State private var isRunning: Bool = true
    
    @State private var player: AVAudioPlayer?
    
    init(initialTime: Int) {
        _timeRemaining = State(initialValue: initialTime)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Time Remaining")
                .font(.headline)
            
            Text(String(format: "%02d : %02d : %02d", (timeRemaining / 3600), (timeRemaining % 3600) / 60, timeRemaining % 60))
                .font(.system(size: 24, weight: .bold))
            
            // 타이머 시작/정지 버튼
            Button {
                toggleTimer()
            } label: {
                Text(isRunning ? "Pause" : "Resume")
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 120, height: 40)
            .background(isRunning ? Color.yellow : Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            // 창 닫기 버튼
            Button {
                closeWindow()
            } label: {
                Text("Close")
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 120, height: 40)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .frame(minWidth: 200, minHeight: 200)
        .onAppear {
            requestNotificationPermission()
            startTimer()
        }
        .onDisappear(perform: stopTimer)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        playAlarmSound()
        showNotification()
        closeWindow()
    }
    
    func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
        isRunning.toggle()
    }
    
    // 창 닫기 함수
    func closeWindow() {
        NSApp.windows.last?.close()
    }
    
    // 알림 소리 재생
    func playAlarmSound() {
        NSSound(named: "Glass")?.play()
    }
    
    // 알림 보내기
    func showNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "The timer has completed."
        
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "TimerFinished", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to deliver notification: \(error.localizedDescription)")
            }
        }
    }

    // 알림 권한 요청
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
}

#Preview {
    TimerView(initialTime: 120)
}

