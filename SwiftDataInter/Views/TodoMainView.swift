//
//  TodoMainView.swift
//  SwiftDataInter
//
//  Created by YoonieMac on 3/10/26.
//

import SwiftUI
import SwiftData

struct TodoMainView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TodoModel]
    
    @State private var showAlert: Bool = false
    @State private var taskTodoDelete: TodoModel?
    @State private var isNewTask: Bool  = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if tasks.isEmpty {
                    Spacer()
                    Text("새로운 할 일을 추가해 주세요 ☝️")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(tasks) { task in
                            NavigationLink {
                                //destination
                            } label: {
                                TaskRowView(task: task)
                                // delete swipe action
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button {
                                            // action
                                            taskTodoDelete = task  // 지울 task를 지정함 이후 alert창이 뜨도록 로직 구성
                                            showAlert = true
                                        } label: {
                                            Text("Delete")
                                        }
                                        .tint(.red)
                                    }
                                // Update completed Task action
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button(Button {
                                            // Action
                                            task.isComplete.toggle()
                                        } label: {
                                            Image(systemName: task.isComplete ? "arrow.uturn.backward.square" : "checkmark.square")
                                        })
                                        .tint(task.isComplete ? .green : .blue)
                                    }
                            } //:NavLink

                        } //:LOOP
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.secondary.opacity(0.3))
                                .padding(.vertical, 5)
                        )
                    } //:LIST
                }//:CONDITIONAL
            } //:VSTACK
            .toolbar {
                // Trailing Icon
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //Action
                        isNewTask.toggle()
                    } label: {
                        Image(systemName: "plus.app.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Color.indigo)
                    }
                }
            } //:TOOLBAR
            .navigationTitle("Todo List")
            .alert("정말로 삭제 하시겠습니까?", isPresented: $showAlert) {
                Button(role: .destructive) {
                    //action
                    guard let taskTodoDelete else {return}
                    modelContext.delete(taskTodoDelete)
                    // SwiftData의 큰 특징: 기본적으로 autosave 기능이 활성화되어 있기 때문에 context 안에 내용 수정, 삭제 등 변경이 있어날 때 값을 자동으로 save() 시켜줌
                } label: {
                    Text("Delete")
                }
            }
        } //:NAVIGATION
    }//:body
}

#Preview("Task 있음") {
    TodoMainView()
        .modelContainer(TodoModel.previewTodo)
}

#Preview("Task 없음") {
    TodoMainView()
}
