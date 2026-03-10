//
//  TaskRowView.swift
//  SwiftDataInter
//
//  Created by YoonieMac on 3/10/26.
//

import SwiftUI

struct TaskRowView: View {
    
    let task: TodoModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(task.taskName)
                        .strikethrough(task.isComplete, color: .red)
                    
                    Image(systemName: task.isImportant ? "exclamationmark.triangle.fill" : "")
                        .foregroundStyle(.red)
                } //:HSTACK
                
                Text(task.formattedDueDate())
                    .font(.caption)
                
            } //:VSTACK
            Spacer()
        } //:HSTACK
    }//:body
}

#Preview {
    
    // SwiftData 가 새로운 모델을 생성할 때 현재 활성화된 ModelContainer를 찾아야 하는데 지정해주지 않으면 Container가 없다고 인식해서 Error 발생
    // 프리뷰에서는 임시 데이터를 사용하기 위해 메모리에만 저장되는 컨테이너를 불러와서 사용해야 error가 없음
    let _ = TodoModel.previewTodo
    let sampleTask = TodoModel(taskName: "완료된 할일", isComplete: true, isImportant: true, dueDate: .now)
    TaskRowView(task: sampleTask)
}
