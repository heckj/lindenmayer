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
    
    init(initialState: State, unitLength: Double) {
        self.initialState = initialState
        self.unitLength = unitLength
    }
    
    func path(rules: [LindenmayerRule]) -> CGPath {
        
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
        
        return path
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
