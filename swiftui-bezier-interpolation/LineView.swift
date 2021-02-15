//
//  LineView.swift
//  swiftui-bezier-interpolation
//
//  Created by Mateus Rodrigues on 12/02/21.
//

import SwiftUI

struct LineView: Shape {
    
    let p0: CGPoint
    let p1: CGPoint
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: p0)
            p.addLine(to: p1)
        }
        .applying(.init(scaleX: rect.width, y: rect.height))
    }
    
}

struct StraightLine_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineView(p0: CGPoint(x: 0.0, y: 0.5), p1: CGPoint(x: 1.0, y: 0.5)).stroke()
            LineView(p0: CGPoint(x: 0.5, y: 0.0), p1: CGPoint(x: 0.5, y: 1.0)).stroke()
        }
        .frame(width: 100, height: 100)
    }
}
