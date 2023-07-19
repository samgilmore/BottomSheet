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
    @State var cornerRadius: CGFloat = 0
    
    var photo: PhotoMetadata
    
    var body: some View {
        let filmPhotoHeight = (1125.0) * (UIScreen.main.bounds.width / 2000.0)
        let smallPhotoHeight = (1125.0) * (UIScreen.main.bounds.width / 900.0)
        let ggbPhotoHeight = (5153.0) * (UIScreen.main.bounds.width / 7726.0)
        
        ZStack {
            GeometryReader { geometry in
                let fractionBar = ((UIScreen.main.bounds.height * 0.87 - ggbPhotoHeight) / 2 ) / ( 0.87 * UIScreen.main.bounds.height)
                
                Image("ggb")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(self.cornerRadius, corners: [.topLeft, .topRight])
                    .offset(y: min(fractionBar * offset, offset - UIScreen.main.bounds.height * 0.35))
                    .edgesIgnoringSafeArea(.all)
            }
            
            BottomSheetView(offset: $offset, startPos: $startPos, cornerRadius: $cornerRadius, photo: photo)
                .offset(y: offset)
                .gesture(DragGesture()
                    .onChanged { value in
                        let dragOffset = value.translation.height + startPos
                        if dragOffset < UIScreen.main.bounds.height * 0.35 {
                            offset = UIScreen.main.bounds.height * 0.35
                        } else if dragOffset > UIScreen.main.bounds.height * 0.87 {
                            offset = UIScreen.main.bounds.height * 0.87
                        } else {
                            offset = dragOffset
                        }
                        
                        // Update cornerRadius. This maps the offset value to a value between 0 and 25.
                        let upperOffsetBound = UIScreen.main.bounds.height * 0.87
                        let lowerOffsetBound = UIScreen.main.bounds.height * 0.35
                        let offsetFraction = 1 - (offset - lowerOffsetBound) / (upperOffsetBound - lowerOffsetBound)
                        
                        cornerRadius = offsetFraction * 25   // 25 is the desired maximum corner radius
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                            if offset > UIScreen.main.bounds.height * 0.6 {
                                offset = UIScreen.main.bounds.height * 0.87
                            } else {
                                offset = UIScreen.main.bounds.height * 0.35
                            }
                        }
                        
                        // Need to update cornerRadius to match the final offset.
                        let upperOffsetBound = UIScreen.main.bounds.height * 0.87
                        let lowerOffsetBound = UIScreen.main.bounds.height * 0.35
                        let offsetFraction = 1 - (offset - lowerOffsetBound) / (upperOffsetBound - lowerOffsetBound)
                        
                        cornerRadius = offsetFraction * 25   // 25 is the desired maximum corner radius
                        
                        startPos = offset
                    }
                )
        }
    }
}

struct BottomSheetView: View {
    @Binding var offset: CGFloat
    @Binding var startPos: CGFloat
    @Binding var cornerRadius: CGFloat
    
    var photo: PhotoMetadata
    
    var body: some View {
        VStack(alignment: .center) {
            
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(Constants.mediumGray)
                .padding(.top, 10)
            
            HStack {
                Image("candle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                    .padding(.trailing, 7)
                
                Text("Kush Shah")
                    .font(Font(UIFont.systemFont(ofSize: 20, weight: .medium, width: .standard)))
                    .foregroundColor(.primary)
                
                Spacer()
                
                ZStack(alignment: .trailing) {
                    Button(action: {
                        // Close the sheet when the button was tapped
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                            offset = UIScreen.main.bounds.height * 0.87
                        }
                        
                        // Need to update cornerRadius to match the final offset.
                        let upperOffsetBound = UIScreen.main.bounds.height * 0.87
                        let lowerOffsetBound = UIScreen.main.bounds.height * 0.35
                        let offsetFraction = 1 - (offset - lowerOffsetBound) / (upperOffsetBound - lowerOffsetBound)
                        
                        cornerRadius = offsetFraction * 25   // 25 is the desired maximum corner radius
                        
                        startPos = offset
                    }) {
                        Image(systemName: "xmark")
                    }
                    .padding(10)
                    .foregroundColor(Constants.darkGray)
                    .background(Constants.lightGray)
                    .clipShape(Circle())
                    .opacity(1 - self.getOpacityFractionButton())
                    
                    Text("Jul 16, 2023")
                        .foregroundColor(Color.gray)
                        .opacity(self.getOpacityFractionDate())
                }
            }
            .padding([.leading, .trailing, .bottom], 20)
            
            VStack(alignment: .leading) {
                Text("Size: \(photo.size)")
                    .padding(.top, 30)
                Text("Format: \(photo.format)")
                Text("Date Taken: \(photo.dateTaken)")
            }
            .padding([.leading, .trailing, .bottom])
        }
        .frame(height: UIScreen.main.bounds.height, alignment: .top)
        .background(Color.white.opacity(1))
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0.0, y: -5)
    }
    
    // Function to calculate opacity for the Button
    func getOpacityFractionButton() -> Double {
        max(min((Double(offset) - UIScreen.main.bounds.height * 0.4) / (UIScreen.main.bounds.height * 0.2), 1), 0)
    }
    
    // Function to calculate opacity for the Date Text
    func getOpacityFractionDate() -> Double {
        max(min((Double(offset) - UIScreen.main.bounds.height * 0.6) / (UIScreen.main.bounds.height * 0.2), 1), 0)
    }
}

struct PhotoMetadata {
    let title: String
    let size: String
    let format: String
    let dateTaken: String
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
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
