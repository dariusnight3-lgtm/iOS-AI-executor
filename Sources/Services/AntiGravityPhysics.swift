import Foundation
import CoreGraphics

class AntiGravityPhysics {
    struct Vector {
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        func magnitude() -> CGFloat {
            return sqrt(x * x + y * y)
        }
        
        mutating func normalize() {
            let mag = magnitude()
            if mag > 0 {
                x /= mag
                y /= mag
            }
        }
    }
    
    struct ForceField {
        let position: CGPoint
        let strength: CGFloat
        let radius: CGFloat
        let isRepulsive: Bool
    }
    
    private var forceFields: [ForceField] = []
    private let gravitationalConstant: CGFloat = 9.81
    
    func addForceField(at position: CGPoint, strength: CGFloat, radius: CGFloat, isRepulsive: Bool = true) {
        forceFields.append(ForceField(position: position, strength: strength, radius: radius, isRepulsive: isRepulsive))
    }
    
    func calculateForce(at position: CGPoint) -> Vector {
        var totalForce = Vector()
        
        for field in forceFields {
            let distance = hypot(position.x - field.position.x, position.y - field.position.y)
            
            if distance < field.radius && distance > 0 {
                let magnitude = (field.strength / (distance * distance)) * (field.isRepulsive ? 1 : -1)
                
                let angle = atan2(position.y - field.position.y, position.x - field.position.x)
                totalForce.x += magnitude * cos(angle)
                totalForce.y += magnitude * sin(angle)
            }
        }
        
        totalForce.y += gravitationalConstant
        
        return totalForce
    }
    
    func updateParticle(position: inout CGPoint, velocity: inout CGPoint, deltaTime: CGFloat) {
        let force = calculateForce(at: position)
        
        velocity.x += force.x * deltaTime
        velocity.y += force.y * deltaTime
        
        position.x += velocity.x * deltaTime
        position.y += velocity.y * deltaTime
    }
}
