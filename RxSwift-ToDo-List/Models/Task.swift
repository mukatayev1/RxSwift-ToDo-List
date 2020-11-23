//
//  Task.swift
//  RxSwift-ToDo-List
//
//  Created by AZM on 2020/11/22.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
