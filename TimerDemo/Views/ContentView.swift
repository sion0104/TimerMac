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
    
    let commonTimes: [(label: String, seconds: Double)] = [
        ("1분", 60),
        ("5분", 300),
        ("15분", 900),
        ("30분", 1800),
        ("1시간", 3600)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Timer Settings")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 20)
                
                HStack(spacing: 20) {
                    ForEach(commonTimes, id: \.label) { time in
                        Button(time.label) {
                            setTimeFromCommon(time: time)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(10)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                HStack(spacing: 20) {
                    TimeInputField(title: "Hours", value: $hourString)
                    TimeInputField(title: "Minutes", value: $minuteString)
                    TimeInputField(title: "Seconds", value: $secondString)
                }
                
                HStack(spacing: 20) {
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
                updateWindowSize()
            }
        }
    }
    
    func startTimer() {
        let hours = Int(hourString) ?? 0
        let minutes = Int(minuteString) ?? 0
        let seconds = Int(secondString) ?? 0
        
        if hours == 0 && minutes == 0 && seconds == 0 {
            showAlert(message: "Please enter a valid time.")
            return
        }
        
        let totalSeconds = hours * 3600 + minutes * 60 + seconds
        createTimerWindow(with: totalSeconds)
    }
    
    func resetInput() {
        hourString = "0"
        minuteString = "0"
        secondString = "0"
    }
    
    func showAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    func createTimerWindow(with seconds: Int) {
        let timerWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 350, height: 100),
                                   styleMask: [.titled, .closable, .resizable],
                                   backing: .buffered,
                                   defer: false)
        
        timerWindow.title = "Timer"
        timerWindow.contentView = NSHostingView(rootView: TimerView(initialTime: seconds))
        timerWindow.makeKeyAndOrderFront(nil)
        timerWindows.append(timerWindow)
    }
    
    func setTimeFromCommon(time: (label: String, seconds: Double)) {
        let currentHours = Int(hourString) ?? 0
        let currentMinutes = Int(minuteString) ?? 0
        let currentSeconds = Int(secondString) ?? 0
        
        let totalSeconds = (currentHours * 3600 + currentMinutes * 60 + currentSeconds) + Int(time.seconds)
        
        let newHours = totalSeconds / 3600
        let newMinutes = (totalSeconds % 3600) / 60
        let newSeconds = totalSeconds % 60
        
        hourString = "\(newHours)"
        minuteString = "\(newMinutes)"
        secondString = "\(newSeconds)"
    }
    
    func updateWindowSize() {
        let contentViewSize = CGSize(width: 200, height: 200)
        if let window = NSApplication.shared.windows.first {
            window.setContentSize(contentViewSize)
        }
    }
}

struct TimeInputField: View {
    let title: String
    @Binding var value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
            TextField("0", text: $value)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(width: 50, height: 30)
                .multilineTextAlignment(.center)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 6).stroke())
        }
    }
}

#Preview {
    ContentView()
}

