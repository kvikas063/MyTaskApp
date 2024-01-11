//
//  TaskDetailView.swift
//  MyTask
//
//  Created by Vikas Kumar on 23/07/23.
//

import SwiftUI

struct TaskDetailView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var showTaskDetailView: Bool
    @Binding var selectedTask: Task
    @State private var showDeleteAlert: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task detail")) {
                    TextField("Task name", text: $selectedTask.name)
                    TextEditor(text: $selectedTask.description)
                    Toggle("Mark complete", isOn: $selectedTask.isCompleted)
                }
                Section(header: Text("Task date/time")) {
                    DatePicker("Task date", selection: $selectedTask.finishDate)
                }
                Section {
                    Button {
                        showDeleteAlert.toggle()
                    } label: {
                        Text("Delete")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .alert("Delete Task?", isPresented: $showDeleteAlert) {
                        Button {
                            showTaskDetailView.toggle()
                        } label: {
                            Text("No")
                        }
                        Button(role: .destructive) {
                            // Delete Task View
                            taskViewModel.deleteTask(task: selectedTask)
                        } label: {
                            Text("Yes")
                        }
                    } message: {
                        Text("Would you like to delete the task \(selectedTask.name)?")
                    }

                }
            }
            .onReceive(taskViewModel.shouldDismiss, perform: { shouldDismiss in
                if shouldDismiss {
                    showTaskDetailView.toggle()
                }
            })
            .navigationTitle("Task Detail")
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
                        // Dismiss Add Task View
                        showTaskDetailView.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Update Task View
                        taskViewModel.updateTask(task: selectedTask)
                    } label: {
                        Text("Update")
                    }.disabled(selectedTask.name.isEmpty)
                }
            }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(taskViewModel: TaskViewModelFactory.createTaskViewModel(),
                       showTaskDetailView: .constant(false),
                       selectedTask: .constant(Task.createEmptyTask()))
    }
}
