//
//  Constants.swift
//  Mod7 Generator
//
//  Created by Jon Alaniz on 8/14/20.
//

import SwiftUI

public func maxHeight() -> CGFloat {
    var height: CGFloat
    
    #if os(macOS)
        height = 328
    #else
        height = .infinity
    #endif
    
    return height
}

public func minHeight() -> CGFloat {
    var height: CGFloat
    
    #if os(macOS)
        height = 328
    #else
        height = 0
    #endif
    
    return height
}

public func width() -> CGFloat {
    var width: CGFloat
    
    #if os(macOS)
        width = 300
    #else
        width = .infinity
    #endif
    
    return width
}
