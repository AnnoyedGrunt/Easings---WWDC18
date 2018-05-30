import Foundation
import UIKit

/**
A cubic bezier curve which uses normalized coordinates for its vertices and control points.
 */

public class UIEditableCurveView: UIView {
    var contentLayer: CAShapeLayer = CAShapeLayer()
    public var path = CGMutablePath()
    
    public var startPoint: CGPoint = CGPoint.zero {
        didSet {
            updatePath()
        }
    }
    
    public var endPoint: CGPoint = CGPoint.zero {
        didSet {
            updatePath()
        }
    }
    
    public var startControl: CGPoint = CGPoint.zero {
        didSet {
            updatePath()
        }
    }
    
    public var endControl: CGPoint = CGPoint.zero {
        didSet {
            updatePath()
        }
    }
    
    public var fillColor: CGColor? {
        get {
            return contentLayer.fillColor
        }
        set {
            contentLayer.fillColor = newValue
        }
        
    }
    
    public var lineColor: CGColor? {
        get {
            return contentLayer.strokeColor
        }
        set {
            contentLayer.strokeColor = newValue
        }
    }
    
    public var linePattern: [NSNumber]? {
        get {
            return contentLayer.lineDashPattern
        }
        set {
            contentLayer.lineDashPattern = newValue
        }
    }
    
    public var lineWidth: CGFloat {
        get {
            return contentLayer.lineWidth
        }
        set {
            contentLayer.lineWidth = newValue
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(contentLayer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been been implemented.")
    }
    
    public func setToLine(start: CGPoint, end: CGPoint) {
        startPoint = start
        startControl = start
        endPoint = end
        endControl = end
    }
    
    func updatePath() {
        path = CGMutablePath()
        path.move(to: startPoint * bounds.size)
        path.addCurve(to: endPoint * bounds.size, control1: startControl * bounds.size, control2: endControl * bounds.size)
        contentLayer.path = path
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        updatePath()
    }
}
