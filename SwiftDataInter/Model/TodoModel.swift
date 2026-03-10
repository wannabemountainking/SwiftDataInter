//
//  TodoModel.swift
//  SwiftDataInter
//
//  Created by YoonieMac on 3/10/26.
//

import Foundation
import SwiftData


@Model
final class TodoModel {
    var taskName: String
    var isComplete: Bool
    var isImportant: Bool
    var dueDate: Date?
    
    init(taskName: String, isComplete: Bool = false, isImportant: Bool, dueDate: Date? = nil) {
        self.taskName = taskName
        self.isComplete = isComplete
        self.isImportant = isImportant
        self.dueDate = dueDate
    }
}

@MainActor
extension TodoModel {
    
    // Preview 용 Mock data 생성 -> container생성
    static var previewTodo: ModelContainer {
        let container: ModelContainer
        do {
            container = try ModelContainer(for: TodoModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        } catch {
            fatalError("Failed to create container: \(error)")
        }
        container.mainContext.insert(TodoModel(taskName: "집 청소 하기", isImportant: false))
        container.mainContext.insert(TodoModel(taskName: "SwiftUI 강의 듣기", isImportant: true))
        
        let dueDataTodo = TodoModel(taskName: "Javascript 연습하기", isImportant: true)
        // 24년 07월 05일
        dueDataTodo.dueDate = dateFormatter().date(from: "24년 07월 05년")
        container.mainContext.insert(dueDataTodo)
        
        let completedTodo = TodoModel(taskName: "빨래하기", isComplete: true, isImportant: false)
        container.mainContext.insert(completedTodo)
        
        try? container.mainContext.save()
        
        return container
    }
    
    // 날짜를 "24년 07월 03일" 형태로 변환하는 함수 추가
    func formattedDueDate() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yy년 MM월 dd일"
        let dateFormatter = TodoModel.dateFormatter()
        guard let dueDate else { return dateFormatter.string(from: Date()) }
        return dateFormatter.string(from: dueDate)
    }
    
    static func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년 MM월 dd일"
        return dateFormatter
    }
}
