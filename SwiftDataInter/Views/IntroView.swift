//
//  IntroView.swift
//  SwiftDataInter
//
//  Created by YoonieMac on 3/9/26.
//

import SwiftUI
import SwiftData

struct IntroView: View {
    
    // @Environment(메모리의 Heap 공간, 도서관 건물 어디서나 사서를 호출할 수 있는 내선 전화)를 사용해서 SwiftData와 소통하는 작업관리자 modelContext(도서관 사서)를 만들고 그 이름도 modelContext라고 선언함.
    @Environment(\.modelContext) private var modelContext
    
    // @Query는 View에서 뭔가 요청을 할 때 View -> modelContext에 저장된 SwiftData 를 요청하고 그 요청된 값을 다시 View 에 자동으로 직접 연결시켜주는 Macro (View <-> modelContext 직접 연결, 그러나 View -> DB는 불가능, 단 DB -> View 만 가능, @FetchRequest와 동일하나 차이점은 @Query는 겉으 코드로 Context가 명시되지 않고 SwiftUI가 알아서 처리)
    @Query private var people: [SampleModel]
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                // Random으로 Data 생성
                let name = ["철수", "영희", "길동"].randomElement()
                let age = [10, 30, 25].randomElement()
                // data를 SampleModel로 지정해서 데이터 넣기
                let person = SampleModel(name: name ?? "", age: age ?? 0)
                // person을 modelContext를 통해 SwiftData에 저장
                modelContext.insert(person)
            } label: {
                Text("사람 추가 하기")
                    .font(.title)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            
            List(people) { person in // SwiftData, CoreData는 모두 DB식별자(ObjectID)는 자동 부여되지만 List등에 사용을 위한 Identifiale 프로토콜 채택을 수동으로 해야하는 CoreData와 달리 SwiftData는 자동으로 Identifiable 채택시켜줌)
                HStack {
                    Text(person.name)
                        .font(.largeTitle)
                    Spacer()
                    Text("\(person.age)세")
                        .bold()
                }
            }
            Spacer()
        } //:VSTACK
    }//:body
}

/*
 SwiftData 순서
 1. Model 만들기 @Model
 2. Container만들기 App 진입기 초기화면에 .modelContainer(for:) 생성
 3. ModelContext 만들기 @Environment에서 만들어 바로 view에 선언
 4. @Query 만들기 context 없이 그냥 model활용해서 배열처럼 만들기
 */

#Preview {
    IntroView()
        .modelContainer(for: SampleModel.self)
}
