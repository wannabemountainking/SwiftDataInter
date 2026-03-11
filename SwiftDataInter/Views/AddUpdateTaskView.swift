//
//  AddUpdateTaskView.swift
//  SwiftDataInter
//
//  Created by YoonieMac on 3/11/26.
//

import SwiftUI
import SwiftData

struct AddUpdateTaskView: View {
    
    
    // MARK: - Property
    // Optional 모델을 이용해서 넘어온 모델이 nil이면 create(add), nil이 아니면 update로 구분해서 사용
    var task: TodoModel?
    
    // 넘어 오는 task 가 없으면 nil -> newTask
    // 넘어 오는 taks 가 있으면 -> update 상황
    var isNewTask: Bool { self.task == nil }
    
    // 환경변수
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // 이 뷰에서 사용할 상태 값
    @State private var taskName: String = ""
    @State private var isImportant: Bool = false
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = false
    
    
    // MARK: - View
    var body: some View {
        Form {
            // 1. TaskName 입력창
            Label {
                // title view
                TextField("여기에 텍스트 입력", text: $taskName)
                    .textFieldStyle(.roundedBorder)
            } icon: {
                Image(systemName: "pencil.circle.fill")
            }
            .padding(.vertical, 10)

            // 2. isImportant 선택창
            VStack(alignment: .leading) {
                Label {
                    // title view
                    Text("이거 중요한 할 일 인가요?")
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                }
                .padding(.vertical, 10)
                // isImportant의 선택 창
                Picker("", selection: $isImportant) {
                    Text("에").tag(true)
                    Text("아니오").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 10)
                
                Divider()
                
                // 3. 마감일 선택창
                Toggle(isOn: $hasDueDate) {
                    Label {
                        // titleView
                        Text("마감일이 있나요?")
                    } icon: {
                        Image(systemName: "calendar.badge.checkmark")
                    }
                }
                .padding(.vertical, 10)
                
                // 마감일 날짜 설정
                if hasDueDate {
                    DatePicker("", selection: $dueDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.vertical, 10)
                }
                
                // 4. 저장, 취소 버튼
                HStack(spacing: 10) {
                    Button(action: {
                        // A. ADD / UPDATE 버튼
                        // 이 버튼은 add 상황일때는 newTask 객체 생성해서 modelContext에 넣어주고
                        // update 상황일 때는 기존 task의 해당 속성에 수정된 데이터 값을 넣어준다.
                        if isNewTask {
                            let newTask = TodoModel(taskName: taskName, isImportant: isImportant)
                            newTask.dueDate = hasDueDate ? self.dueDate : nil
                            modelContext.insert(newTask)
                        } else {
                            task?.taskName = self.taskName
                            task?.isImportant = self.isImportant
                            task?.dueDate = hasDueDate ? self.dueDate : nil
                        }
                        
                        dismiss()
                    }, label: {
                        Text(isNewTask ? "ADD" : "UPDATE")
                            .font(.title2.bold())
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                    .disabled(taskName.isEmpty) // taskName이 비어 있으면 버튼 비활성화
                    
                    // B. CANCEL 버튼
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("CANCLE")
                            .font(.title2.bold())
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } //:HSTACK
            } //:VSTACK
        }//: FORM
        .task { // task가 있는 경우, View가 보이기 전에 SwiftData가 저장된 것을 View에 나타낸다.
            if let task {
                self.taskName = task.taskName
                self.isImportant = task.isImportant
                self.hasDueDate = task.dueDate != nil
                self.dueDate = task.dueDate ?? Date()
            } else {
                self.isImportant = task?.isImportant ?? false
            }
        }
        .navigationTitle(isNewTask ? "ADD TODO" : "UPDATE TODO")
        .navigationBarTitleDisplayMode(.inline)
    }//:body
}

// MARK: - Preview
#Preview("ADD TASK") {
    NavigationStack {
        AddUpdateTaskView()
    }
    .modelContainer(TodoModel.previewTodo)
}

#Preview("EDIT TASK") {
    
    let _ = TodoModel.previewTodo // 바로 사라지지만 일단 어디에 데이터가 저장되어 있는 지 알려줌. 물론 트릭이어서 이것도 사라지고 아래 저장 데이터도 메모리에만 올라감
    let task = TodoModel(taskName: "Edit Something", isImportant: false)
    return NavigationStack {
        AddUpdateTaskView(task: task)
    }
    
}
