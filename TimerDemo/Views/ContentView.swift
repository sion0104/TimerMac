//
//  ContentView.swift
//  TimerDemo
//
//  Created by 최시온 on 1/24/25.
//

import SwiftUI
import AVFoundation
import UserNotifications

struct ContentView: View {
    
    @State private var hourString: String = "0"
    @State private var minuteString: String = "0"
    @State private var secondString: String = "0"
    
    @State private var isShowingTimer: Bool = false
    @State private var timerWindows: [NSWindow] = []
    
    let commonTimes = CommonTimes.all
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
            
                Text("Timer Settings")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 20)
                
                // 자주 이용하는 단위 버튼 출력
                HStack(spacing: 20) {
                    CommonTimerButtonView(hourString: $hourString,
                                          minuteString: $minuteString,
                                          secondString: $secondString)
                }
                
                // 각 시간 단위 입력. 키보드 및 위의 버튼 사용
                HStack(spacing: 20) {
                    TimeInputFieldView(title: "Hours", value: $hourString)
                    TimeInputFieldView(title: "Minutes", value: $minuteString)
                    TimeInputFieldView(title: "Seconds", value: $secondString)
                }
                
                HStack(spacing: 20) {
                    // 시작 버튼
                    Button {
                        startTimer()
                    } label: {
                        Label("Start",systemImage: "play.fill")
                            .frame(width: 120, height: 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    // Text Field 초기화 버튼
                    Button(action: resetInput) {
                        Text("Reset")
                            .frame(width: 120, height: 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
            }
            .padding()
            .frame(maxWidth: 400)
            .navigationTitle("Timer")
            .toolbar {
                // 테마 설정 버튼
                ToolbarItem(placement: .primaryAction) {
                    Menu{
                        Button("Light") { NSApp.appearance = NSAppearance(named: .aqua) }
                        Button("Dark") { NSApp.appearance = NSAppearance(named: .darkAqua) }
                    }label: {
                        Label("System Theme", systemImage: "ellipsis.circle.fill")
                    }
                }
            }
            .onAppear {
                // 앱 실행 시 윈도우 사이즈 조절
                updateWindowSize()
            }
        }
    }
    
    // 타이머 시작
    func startTimer() {
        let hours = Int(hourString) ?? 0
        let minutes = Int(minuteString) ?? 0
        let seconds = Int(secondString) ?? 0
        
        // 모든 시간 입력이 0 인 경우 오류 출력
        if hours == 0 && minutes == 0 && seconds == 0 {
            showAlert(message: "Please enter a valid time.")
            return
        }
        
        let totalSeconds = hours * 3600 + minutes * 60 + seconds
        
        // 총 시간을 계산해 파라미터로 넘겨 새로운 윈도우 생성
        createTimerWindow(with: totalSeconds)
    }
    
    // Reset 버튼 클릭 시 발생
    func resetInput() {
        hourString = "0"
        minuteString = "0"
        secondString = "0"
    }
    
    // alert 창 실행 시 발생
    func showAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    // 새로운 타이머 윈도우 발생 로직
    func createTimerWindow(with seconds: Int) {
        
        // 부모 윈도우가 없는 경우
        guard let parentWindow = NSApplication.shared.windows.first else {
            print("No parent window found")
            return
        }
        
        // 부모 윈도우 기준으로 윈도우 생성 및 크기 설정
        let parentFrame = parentWindow.frame
        let timerWindowFrame = NSRect(x: parentFrame.maxX + 20,
                                      y: parentFrame.minY,
                                      width: 350,
                                      height: 100)
        
        // 새로 생길 윈도우에 대한 소성
        let timerWindow = NSWindow(contentRect: timerWindowFrame,
                                   styleMask: [.titled, .closable, .resizable],
                                   backing: .buffered,
                                   defer: false)
        
        // 윈도우 타이틀 설정
        timerWindow.title = "Timer"
        
        timerWindow.contentView = NSHostingView(rootView: TimerView(initialTime: seconds))
        timerWindow.makeKeyAndOrderFront(nil)
        
        NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: timerWindow, queue: nil) { _ in
            self.timerWindows.removeAll { $0 == timerWindow }
        }
        
        // 생성한 윈도우를 저장
        timerWindows.append(timerWindow)
    }
    
    func updateWindowSize() {
        
        let contentViewSize = CGSize(width: 200, height: 200)
        
        if let window = NSApplication.shared.windows.first {
            window.setContentSize(contentViewSize)
        }
    }
}



#Preview {
    ContentView()
}

