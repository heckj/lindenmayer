//: [Previous](@previous)

import QuartzCore
import PlaygroundSupport
import UIKit

//: ### Drawing container
let bounds = CGRect(x: 0, y: 0, width: 400, height: 400)
let containerView = UIView(frame: bounds)
containerView.backgroundColor = .white
PlaygroundPage.current.liveView = containerView

//: ### Construct curve path
let gosper = Lindenmayer(start: "A",
                         rules: ["A": "A-B--B+A++AA+B-",
                                 "B": "+A-BB--B-A++A+B"],
                         variables: ["A": .draw, "B": .draw, "-": .turn(.left, 60), "+": .turn(.right, 60)])
let rules = gosper.expand(2)
let constructor = LindenmayerConstructor(initialState: .init(0, CGPoint(x: 0, y: 0)), unitLength: 10)
let path = constructor.path(rules: rules, forRect: bounds)

//: ### Configure drawing
let layer = CAShapeLayer()
layer.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
layer.fillColor = nil
layer.strokeColor = UIColor.black.cgColor
layer.path = path
containerView.layer.addSublayer(layer)

//: ### Animate!
let animation = CABasicAnimation(keyPath: "strokeEnd")
animation.fromValue = 0.0
animation.toValue = 1.0
animation.duration = 20.0
layer.add(animation, forKey: nil)

