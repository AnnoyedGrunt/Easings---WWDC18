import Foundation
import UIKit

/**
An UIView rendering a round element which is easily customizable, with a built-in spinning animation and dragging support.
*/
public class UICircleView: UIView {
    public var panGestureRecognizer: UIPanGestureRecognizer?
    let contentLayer: CAShapeLayer = CAShapeLayer()

    public var fillColor: CGColor? {
        get {
            return contentLayer.fillColor
        }
        set {
            contentLayer.fillColor = newValue
        }

    }
    
    public var borderColor: CGColor? {
        get {
            return contentLayer.strokeColor
        }
        set {
            contentLayer.strokeColor = newValue
        }
    }
    
    public var borderPattern: [NSNumber]? {
        get {
            return contentLayer.lineDashPattern
        }
        set {
            contentLayer.lineDashPattern = newValue
        }
    }
    
    public var borderWidth: CGFloat {
        get {
            return contentLayer.lineWidth
        }
        set {
            contentLayer.lineWidth = newValue
        }
    }
    
    public var spinningDuration: CFTimeInterval = 0.0 {
        didSet {
            let key = "transform.rotation.z"
            
            if spinningDuration > 0.0 {
                let animation = CABasicAnimation(keyPath: key)
                animation.duration = spinningDuration
                animation.fromValue = 0
                animation.toValue = CGFloat.pi
                animation.repeatCount = Float.infinity
                contentLayer.add(animation, forKey: key)
            } else {
                contentLayer.removeAnimation(forKey: key)
            }
        }
    }

    public init(radius: Double, draggable: Bool) {
        let rect = CGRect(x: 0.0, y: 0.0, width: radius * 2.0, height: radius * 2.0)
        
        super.init(frame: rect)
        layer.addSublayer(contentLayer)
        updateCircleShape()
        
        if draggable {
            isUserInteractionEnabled = true
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_ :)))
            addGestureRecognizer(panGestureRecognizer!)
        } else {
            isUserInteractionEnabled = false
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    @objc func onPan(_ sender: UIPanGestureRecognizer) {
        guard let parentView = superview else {return}
        let location = sender.location(in: parentView)
        
        if parentView.bounds.minX...parentView.bounds.maxX ~= location.x {
            center.x = location.x
        }

        if parentView.bounds.minY...parentView.bounds.maxY ~= location.y {
            center.y = location.y
        }
    }
    
    public override func layoutSubviews() {
        updateCircleShape()
    }
    
    func updateCircleShape() {
        let diameter = min(bounds.size.width, bounds.size.height)
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        contentLayer.bounds = rect
        contentLayer.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        contentLayer.path = CGPath(ellipseIn: rect, transform: nil)
    }
}
