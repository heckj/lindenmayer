import UIKit

open class LindenmayerView: UIView {
    open var rules: [LindenmayerRule] = []
    open var strokeColor: UIColor = .black
    open var strokeWidth: CGFloat = 2
    open var initialState: LindenmayerConstructor.State = .init(0, .zero)
    open var unitLength: Double = 10
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.isOpaque = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        if let color = backgroundColor {
            ctx.setFillColor(color.cgColor)
            ctx.fill(rect)
        }
        
        if rules.count == 0 {
            return
        }
        
        let constructor = LindenmayerConstructor(initialState: initialState, unitLength: unitLength)
        let path = constructor.path(rules: rules)
        
        // Fit the path into our bounds
        var pathRect = path.boundingBox
        let bounds = self.bounds.insetBy(dx: CGFloat(unitLength), dy: CGFloat(unitLength))
        
        // First make sure the path is aligned with our origin
        var transform = CGAffineTransform(translationX: -pathRect.minX, y: -pathRect.minY)
        var finalPath = path.copy(using: &transform)!
        
        // Next, scale the path to fit snuggly in our path
        pathRect = finalPath.boundingBoxOfPath
        let scale = min(bounds.width / pathRect.width, bounds.height / pathRect.height)
        transform = CGAffineTransform(scaleX: scale, y: scale)
        finalPath = finalPath.copy(using: &transform)!
        
        // Finally, move the path to the correct origin
        transform = CGAffineTransform(translationX: bounds.minX, y: bounds.minY)
        finalPath = finalPath.copy(using: &transform)!
        
        ctx.addPath(finalPath)
        
        ctx.setStrokeColor(self.strokeColor.cgColor)
        ctx.setLineWidth(self.strokeWidth)
        ctx.strokePath()
    }
}
