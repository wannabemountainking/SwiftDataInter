//
//  TodoMainView.swift
//  SwiftDataInter
//
//  Created by YoonieMac on 3/10/26.
//

import SwiftUI
import SwiftData

struct TodoMainView: View {
    
    // MARK: - Property
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TodoModel]
    
    @State private var showAlert: Bool = false
    @State private var taskTodoDelete: TodoModel?
    @State private var isNewTask: Bool  = false
    
    // MARK: - Sort, Filter : @Query 안에서도 할 수 있지만 지저분해서 이미 가져온 Query내용을 정렬, 필터함
    // 1. Sort
    @State private var orderAscending: Bool = true
    private var sortedTodos: [TodoModel] {
        tasks.sorted { orderAscending ? $0.taskName < $1.taskName : $0.taskName > $1.taskName }
    }
    // 2. Filter
    @State private var filterOn: Bool = false
    private var filteredTodos: [TodoModel] {
        // filterOn 일때만 important 한것 출력, 아니면 전체 출력
        filterOn ? tasks.filter { $0.isImportant } : tasks
    }
    
    // MARK: - Sort와 Filter 기능을 같이 사용하기
        // .forward == ascending(오름차순), .reverse == descending(내림차순)
    @State private var sortOrder: SortOrder = .forward
    
    private var sortedAndFilteredTodos: [TodoModel] {
        let sortedTodos = tasks.sorted { sortOrder == .forward ? $0.taskName < $1.taskName : $0.taskName > $1.taskName }
        return filterOn ? sortedTodos.filter { $0.isImportant } : sortedTodos
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                if tasks.isEmpty {
                    // ContentUnAvailable을 써서 예쁘게
                    ContentUnavailableView(
                        "새로운 할 일을 추가해 주세요 ☝️",
                        systemImage: "rectangle.and.pencil.and.ellipsis",
                        description: Text("위의 plus 버튼을 눌러주세요")
                    )
                } else {
                    List {
                        ForEach(sortedAndFilteredTodos) { task in
                            NavigationLink {
                                //destination
                                AddUpdateTaskView(task: task)
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
                                        Button {
                                            // Action
                                            task.isComplete.toggle()
                                        } label: {
                                            Image(systemName: task.isComplete ? "arrow.uturn.backward.square" : "checkmark.square")
                                        }
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
                // Trailing Icons
                
                // MARK: - Sort Button
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        //action
                        sortOrder = (sortOrder == .forward) ? .reverse : .forward
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                            .font(.title2)
                            .foregroundStyle(.green)
                            .symbolVariant(sortOrder == .forward ? .fill : .none)
                    }

                }
                
                // MARK: - Filter Button
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        //action
                        filterOn.toggle()
                    } label: {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.title2)
                            .symbolVariant(filterOn ? .fill : .none)
                    }
                    .tint(.red)
                }
                
                // MARK: - Add Button
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
            .sheet(isPresented: $isNewTask, content: {
                NavigationStack {
                    AddUpdateTaskView()
                }
            })
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
