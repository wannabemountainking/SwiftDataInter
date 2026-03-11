//
//  SwiftDataInterApp.swift
//  SwiftDataInter
//
//  Created by YoonieMac on 3/9/26.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataInterApp: App {
    var body: some Scene {
        WindowGroup {
//            IntroView()
//            // Model Containeer 생성 및 전달 -> IntroView에서 SampleModel에 해당하는 SwiftData를 생성하고 전달(자동으로)
//                .modelContainer(for: SampleModel.self)
            TodoMainView()
                .modelContainer(for: TodoModel.self)
        }
    }
}
