//
//  CommonTimes.swift
//  TimerDemo
//
//  Created by 최시온 on 1/24/25.
//

import Foundation

// 사용자들이 자주 이용하는 시간 단위 구조체
struct CommonTimes {
    static let all: [(label: String, seconds: Double)] = [
        ("1분", 60),
        ("5분", 300),
        ("15분", 900),
        ("30분", 1800),
        ("1시간", 3600)
    ]
}
