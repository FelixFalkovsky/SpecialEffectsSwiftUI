//
//  ContentView.swift
//  SpecialEffectsSwiftUI
//
//  Created by Felix on 29.01.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var particleSystem = ParticleSystem()
    @State private var motionHandler = MotionManager()
    @State private var spartColor = Color.blue
    
    let options: [(flipX: Bool, flipY: Bool)] = [
        (false, false),
        (true, false),
        (false, true),
        (true, true)
    ]
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let timelineDate = timeline.date.timeIntervalSinceReferenceDate
                particleSystem.update(date: timelineDate)
                
                // Update coordinate state when using device tilt
                particleSystem.center = UnitPoint(x: 0.5 + motionHandler.roll, y: 0.5 + motionHandler.pitch)
                
                context.blendMode = .plusLighter
                //context.blendMode = .plusDarker
                //context.addFilter(.colorMultiply(.blue))
                
                for particle in particleSystem.particles {
                    var contextCopy = context
                    contextCopy.addFilter(.colorMultiply(Color(hue: particle.hue, saturation: 1, brightness: 1)))
                    
                    contextCopy.opacity = 1 - (timelineDate - particle.creationDate)
                    
                    for option in options {
                        var xPos = particle.x * size.width
                        var yPos = particle.y * size.height
                        
                        if option.flipX {
                            xPos = size.width - xPos
                        }
                        
                        if option.flipY {
                            yPos = size.height - yPos
                        }
                        
                        contextCopy.draw(particleSystem.image, at: CGPoint(x: xPos, y: yPos))
                    }
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ drag in
                    self.particleSystem.center.x = drag.location.x / UIScreen.main.bounds.width
                    self.particleSystem.center.y = drag.location.y / UIScreen.main.bounds.height
                })
        )
        .ignoresSafeArea()
        .background(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
