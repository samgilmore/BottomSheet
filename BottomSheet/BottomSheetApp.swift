//
//  BottomSheetApp.swift
//  BottomSheet
//
//  Created by Sam Gilmore on 7/17/23.
//

import SwiftUI

@main
struct BottomSheetApp: App {
    var samplePhoto = PhotoMetadata(
        title: "Sample photo",
        size: "1920x1080",
        format: "JPEG",
        dateTaken: "5th July, 2023"
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView(photo: samplePhoto)
        }
    }
}
