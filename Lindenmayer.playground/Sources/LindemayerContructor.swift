import Foundation
import CoreGraphics

open class LindenmayerConstructor {
    
    public struct State {
        var angle: Double
        var position: CGPoint
        
        public init(_ angle: Double, _ position: CGPoint) {
            self.angle = angle
            self.position = position
        }
    }
    
    let initialState: State
    let unitLength: Double
    
    public init(initialState: State, unitLength: Double) {
        self.initialState = initialState
        self.unitLength = unitLength
    }
    
    public func path(rules: [LindenmayerRule], forRect destinationRect: CGRect? = nil) -> CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        
        var state = [State]()
        var currentState = initialState
        
        for rule in rules {
            switch rule {
            case .storeState:
                state.append(currentState)
            case .restoreState:
                currentState = state.removeLast()
                path.move(to: currentState.position)
            case .move:
                currentState = calculateState(currentState, distance: self.unitLength)
                path.move(to: currentState.position)
            case .draw:
                currentState = calculateState(currentState, distance: self.unitLength)
                path.addLine(to: currentState.position)
            case .turn(let direction, let angle):
                currentState = calculateState(currentState, angle: angle, direction: direction)
            case .ignore:
                break
            }
        }
        
        guard let destinationRect = destinationRect else {
            return path
        }
        
        // Fit the path into our bounds
        var pathRect = path.boundingBox
        let containerRect = destinationRect.insetBy(dx: CGFloat(unitLength), dy: CGFloat(unitLength))
        
        // First make sure the path is aligned with our origin
        var transform = CGAffineTransform(translationX: -pathRect.minX, y: -pathRect.minY)
        var transformedPath = path.copy(using: &transform)!
        
        // Next, scale the path to fit snuggly in our path
        pathRect = transformedPath.boundingBoxOfPath
        let scale = min(containerRect.width / pathRect.width, containerRect.height / pathRect.height)
        transform = CGAffineTransform(scaleX: scale, y: scale)
        transformedPath = transformedPath.copy(using: &transform)!
        
        // Finally, move the path to the correct origin
        transform = CGAffineTransform(translationX: containerRect.minX, y: containerRect.minY)
        transformedPath = transformedPath.copy(using: &transform)!
        
        return transformedPath
    }
    
    // MARK: - Private
    
    fileprivate func degreesToRadians(_ value: Double) -> Double {
        return value * M_PI / 180.0
    }
    
    fileprivate func calculateState(_ state: State, distance: Double) -> State {
        let x = state.position.x + CGFloat(distance * cos(self.degreesToRadians(state.angle)))
        let y = state.position.y + CGFloat(distance * sin(self.degreesToRadians(state.angle)))
        
        return State(state.angle, CGPoint(x: x, y: y))
    }
    
    fileprivate func calculateState(_ state: State, angle: Double, direction: LindenmayerDirection) -> State {
        if direction == .left {
            return State(state.angle - angle, state.position)
        }
        
        return State(state.angle + angle, state.position)
    }
    
}
