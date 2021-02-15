//
//  ContentView.swift
//  swiftui-bezier-interpolation
//
//  Created by Mateus Rodrigues on 11/02/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selected = 0
    @State private var x: CGFloat = 0
    @State private var value1: CGFloat = 0
    @State private var value2: CGFloat = 0
    @State private var duration = 5.0
    
    var curves = ["linear", "easeIn", "easeOut", "easeInOut"]
    
    var _animation: _Animation {
        switch selected {
            case 0:
                return .linear(duration: duration)
            case 1:
                return .easeIn(duration: duration)
            case 2:
                return .easeOut(duration: duration)
            case 3:
                return .easeInOut(duration: duration)
            default:
                return .linear
        }
    }
    
    var animation: Animation {
        switch selected {
            case 0:
                return .linear(duration: duration)
            case 1:
                return .easeIn(duration: duration)
            case 2:
                return .easeOut(duration: duration)
            case 3:
                return .easeInOut(duration: duration)
            default:
                return .default
        }
    }
    
    var body: some View {
        VStack {

            Picker("select an animation curve", selection: $selected.animation()) {
                ForEach(0 ..< curves.count) {
                    Text(curves[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()

            AnimationView(x: $x, animation: _animation)

            OffsetSquare(label: "_Animation", value: value1)
                .frame(height: 100)
            OffsetSquare(label: "Animation", value: value2)
                .frame(height: 100)
            

            HStack {

                Button("Start") {
                    _animation.interpolate(from: 0, to: 1) {
                        x = $0
                        value1 = $1
                    }
                    withAnimation(animation) {
                        value2 = 1
                    }
                }
                
                Divider()

                Button("Reset") {
                    withAnimation {
                        x = 0
                        value1 = 0
                        value2 = 0
                    }
                }
                
                Divider()
                
                Stepper("duration = \(Int(duration))s", value: $duration, in: 0...5)
                    .font(.system(.body, design: .monospaced))

            }
            .frame(height: 20)

        }
        .padding()
    }
    
}


struct OffsetSquare: View {
    
    let label: String
    let value: CGFloat
    
    var body: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.blue)
                .frame(width: proxy.size.height, height: proxy.size.height)
                .overlay(Text(label).foregroundColor(.white))
                .offset(x: value*(proxy.size.width-proxy.size.height))
                .frame(width: proxy.size.width, alignment: .leading)
        }
        .padding(5)
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color.gray))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
