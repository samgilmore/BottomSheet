//
//  ContentView.swift
//  BottomSheet
//
//  Created by Sam Gilmore on 7/17/23.
//

import SwiftUI

struct ContentView: View {
    @State var offset: CGFloat = UIScreen.main.bounds.height * 0.87
    @State var startPos: CGFloat = UIScreen.main.bounds.height * 0.87
    
    var photo: PhotoMetadata
    
    var body: some View {
        ZStack {
            VStack {
                Text("This is the main content")
                    .font(.largeTitle)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
            .edgesIgnoringSafeArea(.all)
            
            BottomSheetView(photo: photo)
                .offset(y: offset)
                .shadow(color: .gray, radius: 5, x: 0, y: -5)
                .gesture(DragGesture()
                    .onChanged { value in
                        let dragOffset = value.translation.height + startPos
                        if dragOffset < UIScreen.main.bounds.height / 2 {
                            offset = UIScreen.main.bounds.height / 2
                        } else if dragOffset > UIScreen.main.bounds.height * 0.87 {
                            offset = UIScreen.main.bounds.height * 0.87
                        } else {
                            offset = dragOffset
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if offset > UIScreen.main.bounds.height * 0.75 {
                                offset = UIScreen.main.bounds.height * 0.87
                            } else {
                                offset = UIScreen.main.bounds.height / 2
                            }
                        }
                        startPos = offset
                    }
                )
        }
    }
}

struct BottomSheetView: View {
    var photo: PhotoMetadata
    
    var body: some View {
        VStack(alignment: .center) {
            Capsule()
                .frame(width: 50, height: 5)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            HStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 50, height: 50)
                
                Text("Username")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("Jul 5, 2023")
                    .foregroundColor(.gray)
            }
            .padding([.leading, .trailing, .bottom])
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("Size: \(photo.size)")
                Text("Format: \(photo.format)")
                Text("Date Taken: \(photo.dateTaken)")
            }
            .padding([.leading, .trailing, .bottom])
        }
        .frame(height: UIScreen.main.bounds.height, alignment: .top)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct PhotoMetadata {
    let title: String
    let size: String
    let format: String
    let dateTaken: String
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(photo: PhotoMetadata(
            title: "Sample photo",
            size: "1920x1080",
            format: "JPEG",
            dateTaken: "5th July, 2023"
        ))
    }
}
