//
//  solve.swift
//  swiftui-bezier-interpolation
//
//  Created by Mateus Rodrigues on 11/02/21.
//

import SwiftUI

struct Complex {
    
    var real: Double
    var imaginary: Double
    
    public init(_ real: Double, _ imaginary: Double) {
        self.real = real
        self.imaginary = imaginary
    }
    
    public init(_ real: Double) {
        self.real = real
        self.imaginary = 0
    }
    
    var isReal: Bool {
        if imaginary == 0 { return true }
        return false
    }
}

func solve(a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat, threshold: Double = 0.0001) -> [Complex] {
  
    var roots = [Complex]()
    
    let a_1 = Double(b/a)
    let a_2 = Double(c/a)
    let a_3 = Double(d/a)
    
    let q = (3*a_2 - pow(a_1, 2))/9
    let r = (9*a_1*a_2 - 27*a_3 - 2*pow(a_1, 3))/54
    
    let s = cbrt(r + sqrt(pow(q, 3)+pow(r, 2)))
    let t = cbrt(r - sqrt(pow(q, 3)+pow(r, 2)))
    
    var d = pow(q, 3) + pow(r, 2)

    if -threshold < d && d < threshold { d = 0 }
    
    if d > 0 {
        let x_1 = Complex(s + t - (1/3)*a_1)
        let x_2 = Complex(-(1/2)*(s+t) - (1/3)*a_1,  (1/2)*sqrt(3)*(s - t))
        let x_3 = Complex(-(1/2)*(s+t) - (1/3)*a_1,  -(1/2)*sqrt(3)*(s - t))
        roots = [x_1, x_2, x_3]
        
    } else {
        let theta = acos(r/sqrt(-pow(q, 3)))
        let x_1 = Complex(2*sqrt(-q)*cos((1/3)*theta) - (1/3)*a_1)
        let x_2 = Complex(2*sqrt(-q)*cos((1/3)*theta + 2*Double.pi/3) - (1/3)*a_1)
        let x_3 = Complex(2*sqrt(-q)*cos((1/3)*theta + 4*Double.pi/3) - (1/3)*a_1)
        roots = [x_1, x_2, x_3]
     }
    
    return roots
}
