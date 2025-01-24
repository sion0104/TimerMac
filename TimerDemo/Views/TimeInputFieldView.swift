//
//  TimeInputFieldView.swift
//  TimerDemo
//
//  Created by 최시온 on 1/24/25.
//

import SwiftUI

struct TimeInputFieldView: View {
    let title: String
    @Binding var value: String
    
    // 시간 입력 View 디자인 통일
    
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

