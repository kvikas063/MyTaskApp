//
//  TaskViewModel.swift
//  MyTask
//
//  Created by Vikas Kumar on 16/07/23.
//

import Foundation
import Combine

final class TaskViewModel: ObservableObject {
    
    @Published var tasks: [Task] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    private var cancellable = Set<AnyCancellable>()
    private var _isCompleted: Bool = false
    var shouldDismiss = PassthroughSubject<Bool, Never>()

    private let taskRepository: TaskRepository
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    deinit {
        cancelSubcription()
    }
    
    func cancelSubcription() {
        cancellable.forEach { $0.cancel() }
    }
    
    func getTasks(isCompleted: Bool) {
        _isCompleted = isCompleted
        taskRepository.get(isCompleted: !isCompleted).sink { [weak self] fetchOperationResult in
            switch fetchOperationResult {
            case .success(let fetchedTasks):
                self?.errorMessage = ""
                self?.tasks = fetchedTasks
            case .failure(let failure):
                self?.processOperationError(failure)
            }
        }.store(in: &cancellable)
    }
    
    func addTask(task: Task) {
        taskRepository.add(task: task).sink { [weak self] addOperationResult in
            self?.processOperationResult(operationResult: addOperationResult)
        }.store(in: &cancellable)
    }
    
    func updateTask(task: Task) {
        taskRepository.update(task: task).sink { [weak self] updateOperationResult in
            self?.processOperationResult(operationResult: updateOperationResult)
        }.store(in: &cancellable)
    }
    
    func deleteTask(task: Task) {
        taskRepository.delete(task: task).sink { [weak self] deleteOperationResult in
            self?.processOperationResult(operationResult: deleteOperationResult)
        }.store(in: &cancellable)
    }
    
    private func processOperationResult(operationResult: Result<Bool, TaskRepositoryError>) {
        switch operationResult {
        case .success(_):
            self.errorMessage = ""
            self.getTasks(isCompleted: _isCompleted)
            self.shouldDismiss.send(true)
        case .failure(let failure):
            self.processOperationError(failure)
        }
    }
    
    private func processOperationError(_ error: TaskRepositoryError) {
        switch error {
        case .operationFailure(let errorMessage):
            self.showError = true
            self.errorMessage = errorMessage
        }
    }
}
