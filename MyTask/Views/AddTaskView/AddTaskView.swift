//
//  AddTaskView.swift
//  MyTask
//
//  Created by Vikas Kumar on 23/07/23.
//

import SwiftUI

struct AddTaskView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var taskToAdd: Task = Task.createEmptyTask()
    @Binding var showAddTaskView: Bool
    @State private var showDirtyCheckAlert: Bool = false

    var pickerDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDateComponent = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        let startDateComponent = DateComponents(year: currentDateComponent.year, month: currentDateComponent.month, day: currentDateComponent.day, hour: currentDateComponent.hour, minute: currentDateComponent.minute)
        let endDateComponent = DateComponents(year: 2024, month: 12, day: 31)
        
        return calendar.date(from: startDateComponent)! ... calendar.date(from: endDateComponent)!
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task detail")) {
                    TextField("Task name", text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                Section(header: Text("Task date/time")) {
                    DatePicker("Task date", selection: $taskToAdd.finishDate, in: pickerDateRange)
                }
            }
            .onReceive(taskViewModel.shouldDismiss, perform: { shouldDismiss in
                if shouldDismiss {
                    showAddTaskView.toggle()
                }
            })
            .navigationTitle("Add Task")
            .alert("Task Error", isPresented: $taskViewModel.showError) {
                Button(action: {}) {
                    Text("OK")
                }
            } message: {
                Text(taskViewModel.errorMessage)
            }
            .onDisappear {
                taskViewModel.cancelSubcription()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if !taskToAdd.name.isEmpty {
                            // Show Alert
                            showDirtyCheckAlert.toggle()
                        } else {
                            // Dismiss Add Task View
                            showAddTaskView.toggle()
                        }
                    } label: {
                        Text("Cancel")
                    }
                    .alert("Save Task", isPresented: $showDirtyCheckAlert) {
                        Button {
                            // Dismiss Add Task View
                            showAddTaskView.toggle()
                        } label: {
                            Text("Cancel")
                        }
                        Button {
                            addTask()
                        } label: {
                            Text("Save")
                        }
                    } message: {
                        Text("Would you like to save the task?")
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Save Add Task View
                        addTask()
                    } label: {
                        Text("Add")
                    }.disabled(taskToAdd.name.isEmpty)
                }
            }
        }
    }
    
    private func addTask() {
        taskViewModel.addTask(task: taskToAdd)
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(taskViewModel: TaskViewModelFactory.createTaskViewModel(),
                    showAddTaskView: .constant(false))
    }
}
