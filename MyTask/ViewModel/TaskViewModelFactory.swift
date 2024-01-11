//
//  TaskViewModelFactory.swift
//  MyTask
//
//  Created by Vikas Kumar on 02/10/23.
//

import Foundation

final class TaskViewModelFactory {
    static func createTaskViewModel() -> TaskViewModel {
        return TaskViewModel(taskRepository: TaskRepositoryImplementation())
    }
}
