//
//  CommonTimerButtonView.swift
//  TimerDemo
//
//  Created by 최시온 on 1/24/25.
//

import SwiftUI

struct CommonTimerButtonView: View {
    @Binding private var hourString: String
    @Binding private var minuteString: String
    @Binding private var secondString: String
    
    let commonTimes = CommonTimes.all
    
    init(hourString: Binding<String>, minuteString: Binding<String>, secondString: Binding<String>) {
        self._hourString = hourString
        self._minuteString = minuteString
        self._secondString = secondString
    }
    
    // 자주 이용하는 시간 단위 모델을 일괄 출력
    var body: some View {
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
}

