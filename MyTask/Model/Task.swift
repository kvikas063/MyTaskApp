//
//  Task.swift
//  MyTask
//
//  Created by Vikas Kumar on 16/07/23.
//

import Foundation

struct Task {
    let id: UUID
    var name: String
    var description: String
    var isCompleted: Bool
    var finishDate: Date
    
    static func createEmptyTask() -> Task {
        Task(id: UUID(), name: "", description: "", isCompleted: false, finishDate: Date())
    }
}
