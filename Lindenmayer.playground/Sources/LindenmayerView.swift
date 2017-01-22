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
        let path = constructor.path(rules: rules, forRect: bounds)
        
        ctx.addPath(path)
        ctx.setStrokeColor(self.strokeColor.cgColor)
        ctx.setLineWidth(self.strokeWidth)
        ctx.strokePath()
    }
}
