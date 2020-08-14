//
//  ContentView.swift
//  Shared
//
//  Created by Jon Alaniz on 8/13/20.
//

import SpriteKit
import SwiftUI

struct ContentView: View {
    @ObservedObject var generator = Generator()
    @State private var selectedKey = 0
    
    var keyTypes = ["Windows 95", "Office 97"]
    var scene: SKScene {
        let scene = AnimationScene()
        scene.size = CGSize(width: 480, height: 272)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        VStack(spacing: 0) {
            #if os(macOS)
            SpriteView(scene: scene)
                .frame(width: width(), height: width() / 1.77, alignment: .center)
            #else
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
            #endif
            
            HStack(spacing: 4) {
                Picker(selection: $selectedKey, label: Text("Key Type")) {
                    ForEach(0 ..< keyTypes.count) {
                        Text(self.keyTypes[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                
                Spacer()
                
                Button(action: {
                    generator.refresh()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .padding()
            
            List {
                if selectedKey == 0 {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("OEM:")
                            .font(.headline)
                            .bold()
                        
                        Text(generator.windows95OEMKey)
                        
                        Text("Retail:")
                            .font(.headline)
                            .bold()
                        
                        Text(generator.windows95RetailKey)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Retail:")
                            .font(.headline)
                            .bold()
                        
                        Text(generator.office97Key)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            
        }
        .onAppear {
            generator.refresh()
        }
        .frame(maxWidth: width(), maxHeight: height())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
