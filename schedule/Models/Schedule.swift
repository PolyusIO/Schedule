//
//  Models.swift
//  schedule
//
//  Created by Сергей Поляков on 30.07.2023.
//

struct DailySchedule: Decodable {
    let date: String
    let weekDay: String
    let isCurrentDate: Int
    let pairs: [Pair]
}

struct Pair: Decodable {
    let N: Int
    let time: String
    let isCurrentPair: Int
    let schedulePairs: [Subject]
    
    var description: String {
        "Пара \(N): \(time)"
    }
}

struct Subject: Decodable {
    let subject: String
    let teacher: String
    let group: String
    let aud: String
    let comm: String
    
    var description: String {
        """
        \(subject)
        Преподаватель \(teacher)
        Аудитория \(aud)
        """
    }
}
