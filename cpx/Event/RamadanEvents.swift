//
//  RamadanEvents.swift
//  Moon
//
//  Created by PYTHON on 07/03/24.
//

import Foundation

// MARK: - Ramadan specific events names here

class RamadanEventName {
    static let showAnswer: String = "show_answer_click"
}

// MARK: - Ramadan specific parameters events names here

class RamadanEventParameterName {}

// MARK: - Ramadan events

enum RamadanEvent {
    @Event(name: RamadanEventName.showAnswer)
    static var showAnswer: Event
}
