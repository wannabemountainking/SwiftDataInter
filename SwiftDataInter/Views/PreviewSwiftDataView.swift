//
//  PreviewSwiftDataView.swift
//  SwiftDataInter
//
//  Created by YoonieMac on 3/9/26.
//

import SwiftUI
import SwiftData

struct PreviewSwiftDataView: View {
    
    // mainContext와 연결
    @Query private var people2: [PreviewModel]
    
    var body: some View {
        List(people2) { person in // SwiftData, CoreData는 모두 DB식별자(ObjectID)는 자동 부여되지만 List등에 사용을 위한 Identifiale 프로토콜 채택을 수동으로 해야하는 CoreData와 달리 SwiftData는 자동으로 Identifiable 채택시켜줌)
            HStack {
                Text(person.name)
                    .font(.largeTitle)
                Spacer()
                Text("\(person.age)세")
                    .bold()
            }
        }
    }
}

#Preview {
    PreviewSwiftDataView()
        .modelContainer(PreviewModel.previewData)
}
