//
//  HomeView.swift
//  MyTask
//
//  Created by Vikas Kumar on 19/07/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var taskViewModel: TaskViewModel = TaskViewModelFactory.createTaskViewModel()
    @State private var defaultPickerSelectedItem: String = "Active"
    @State private var showAddTaskView: Bool = false
    @State private var showTaskDetailView: Bool = false
    @State private var selectedTask: Task = Task.createEmptyTask()
    @State private var showErrorAlert: Bool = false

    var body: some View {
        NavigationStack {
            PickerComponent(defaultPickerSelectedItem: $defaultPickerSelectedItem)
            .onChange(of: defaultPickerSelectedItem) { newValue in
                taskViewModel.getTasks(isCompleted: defaultPickerSelectedItem == "Active")
            }
            .onChange(of: taskViewModel.errorMessage) { _ in
                showErrorAlert.toggle()
            }
            .alert("Task Error", isPresented: $taskViewModel.showError) {
                Button(action: {}) {
                    Text("OK")
                }
            } message: {
                Text(taskViewModel.errorMessage)
            }
            
            List(taskViewModel.tasks, id: \.id) { task in
                VStack(alignment: .leading) {
                    Text(task.name).font(.title)
                    HStack {
                        Text(task.description).font(.subheadline)
                            .lineLimit(1)
                        Spacer()
                        Text(task.finishDate.toString()).font(.subheadline)
                    }
                }
                .onTapGesture {
                    selectedTask = task
                    showTaskDetailView.toggle()
                }
            }
            .listStyle(.plain)
            .onAppear {
                taskViewModel.getTasks(isCompleted: true)
            }
            .onDisappear {
                taskViewModel.cancelSubcription()
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Add Task View
                        showAddTaskView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .fullScreenCover(isPresented: $showAddTaskView) {
                AddTaskView(taskViewModel: taskViewModel,
                            showAddTaskView: $showAddTaskView)
            }
            .fullScreenCover(isPresented: $showTaskDetailView) {
                TaskDetailView(taskViewModel: taskViewModel,
                               showTaskDetailView: $showTaskDetailView,
                               selectedTask: $selectedTask)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
