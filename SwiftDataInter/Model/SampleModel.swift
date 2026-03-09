//
//  SampleModel.swift
//  SwiftDataInter
//
//  Created by YoonieMac on 3/9/26.
//

import Foundation
import SwiftData // SwiftData를 사용하는 file에서는 SwiftData를 import 해서 @Model과 같은 macro를 사용할 수 있음


@Model  // 이 매크로는 다음 클래스를 SwiftData에 영구적으로 저장시킬 수 있게 만들어줌. 타입 선언 앞에 명기
class SampleModel {
    /*
     기존 Core Data의 Model 형식은 @NSManaged 프로퍼티 래퍼를 사용해서 런타임에 Core Data에서 값을 직접 주입하기 때문에 이를 개발자가 초기화 할 필요가 없었지만(런타임 주입방식) @Model은 반드시 초기화를해야 함(Swift 네이티브 방식) 두 방식은 모두 해당 클래스가 각각 ObservableObject, Observable 프로토콜을 각각 채택해서 @Published 없이 View에서 자동으로 관찰하기 때문에(Core Data에서는 @ObservedObject, SwiftData에서는 @Bindable을 써줘야 감시가 명시됨, 단 CoreData는 수동호출 ObjectWillChange.send()을 해줘야 할 때가 있음(주로 중첩객체, 수동변경시)) 값이 변경되면 View도 화면을 다시그린다.
     */
    var name: String
    var age: Int
    
    // Swift Native 방식을 사용하므로 init값 설정 필요
    init(name: String = "", age: Int = 0) {
        self.name = name
        self.age = age
    }
}



