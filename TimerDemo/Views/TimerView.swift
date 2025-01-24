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


// 새로운 윈도우에 대한 View
struct TimerView: View {
    @State private var timeRemaining: Int
    @State private var timer: Timer? = nil
    @State private var isRunning: Bool = true
        
    // 부모 뷰에서 총 시간 정보를 받아옴.
    init(initialTime: Int) {
        _timeRemaining = State(initialValue: initialTime)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Time Remaining")
                .font(.headline)
            
            // 남은 시간 표시
            Text(String(format: "%02d : %02d : %02d", (timeRemaining / 3600), (timeRemaining % 3600) / 60, timeRemaining % 60))
                .font(.system(size: 24, weight: .bold))
            
            // 재시작 및 정지 버튼
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
            
            // 닫기 버튼
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
            // 앱 실행 시 알림 허가 요청 및 타이머 실행
            requestNotificationPermission()
            startTimer()
        }
        .onDisappear(perform: stopTimer)
    }
    
    
    func startTimer() {
        // 타이머 로직
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // 시간이 끝난 경우 타이머 종료 및 알람, 소리 재생 그리고 윈도우 닫기
                stopTimer()
                handleTimerCompletion()
                closeWindow()
            }
        }
    }
    
    func stopTimer() {
        // 타이머가 멈춘 경우
        timer?.invalidate()
        timer = nil
    }
    
    func handleTimerCompletion() {
        // 알람 및 소리 재생
        playAlarmSound()
        showNotification()
    }
    
    func toggleTimer() {
        // 재생 및 멈춤 버튼 실행 시 발생 로직
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
        isRunning.toggle()
    }
    
    func closeWindow() {
        // 타이머 종료 후 윈도우 닫기
        stopTimer()
        NSApp.windows.last?.close()
    }
    
    func playAlarmSound() {
        // 소리 재생
        NSSound(named: "Glass")?.play()
    }
    
    func showNotification() {
        // 알림을 위한 로직.
        
        // 알림에 관한 설정
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "The timer has completed."
        content.sound = UNNotificationSound.default
        
        // 저장된 알림에 대한 요청
        let request = UNNotificationRequest(identifier: "TimerFinished", content: content, trigger: nil)
        
        // 요청 추가
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to deliver notification: \(error.localizedDescription)")
            }
        }
    }

    func requestNotificationPermission() {
        // 알림 허가 요청
        
        // 이미 허가 되있는 경우, 사용자에게 허가 요청 창이 보인다.
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

