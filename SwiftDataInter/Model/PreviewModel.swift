//
//  PreviewModel.swift
//  SwiftDataInter
//
//  Created by YoonieMac on 3/9/26.
//

import Foundation
import SwiftData


@Model
final class PreviewModel {
    var name: String
    var age: Int
    
    init(name: String = "", age: Int = 0) {
        self.name = name
        self.age = age
    }
}

// Preview 에서 사용할 수 있는 Mock Data (가짜 데이터) 생성하기  -> Preview에서만 사용할 수 있는 ModelContainer 수동 생성

extension PreviewModel {
    // 1. ModelContainer 생성
    
    // @MainActor는 @MainActor 아래의 코드가 main thread에서 실행되게끔 보장 설정
    @MainActor
    static var previewData: ModelContainer {
        let container: ModelContainer
        
        do {
            container = try ModelContainer(
                for: PreviewModel.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
                // isStoredInMemoryOnly 는 Preview에서만 사용될 것이기 때문에 Mock Data를 영구데이터가 아니라 memory상에서만 임시 저장
            )
        } catch {
            fatalError("Failed to Create ModelContainer: \(error)")
        }
        
        // 2. 데이터 생성
        let names = ["철수", "영희", "길동"]
        let ages = [10, 30, 25]
        
        // 5개의 Random MockData를 반복문으로 생성
        for _ in 0 ..< 5 {
            let name = names.randomElement() ?? ""
            let age = ages.randomElement() ?? 0
            let person = PreviewModel(name: name, age: age)
            
            // 3. 생성된 데이터를 container에 저장 (집어 넣기)
            // Container.mainContext는 UI 관련 업데이트이기 때문에 메인 스레드에서 수행되어야 하기 때문에 반드시 Main Thread에서 실행되게끔 보장되어야 함
            container.mainContext.insert(person)
        }
        return container
    }
}
