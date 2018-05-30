import Foundation
import UIKit

/**
A simple graphical element that renders a customizable grid pattern along with a gradient.
*/

public class UIChartView: UIView {
    
    public var lineWidth: CGFloat = 1.0
    public var lineColor: CGColor? {
        get {
            return horizontalLineLayer.backgroundColor
        }
        set {
            horizontalLineLayer.backgroundColor = newValue
            verticalLineLayer.backgroundColor = newValue
        }
    }
    
    public var horizontalLineCount: Int {
        get {
            return horizontalPatternLayer.instanceCount
        }
        set {
            horizontalPatternLayer.instanceCount = newValue
            setNeedsLayout()
        }
    }
    
    public var verticalLineCount: Int {
        get {
            return verticalPatternLayer.instanceCount
        }
        set {
            verticalPatternLayer.instanceCount = newValue
            setNeedsLayout()
        }
    }
    
    public var topColor: CGColor {
        get {
            return gradientLayer.colors!.first! as! CGColor
        }
        set {
            gradientLayer.colors?[0] = newValue
        }
    }
    
    public var bottomColor: CGColor {
        get {
            return gradientLayer.colors!.last! as! CGColor
        }
        set {
            gradientLayer.colors?[1] = newValue
        }
    }
    
    let gradientLayer = CAGradientLayer()
    let horizontalPatternLayer = CAReplicatorLayer()
    let verticalPatternLayer = CAReplicatorLayer()
    let horizontalLineLayer = CALayer()
    let verticalLineLayer = CALayer()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        //Gradient setup
        gradientLayer.anchorPoint = CGPoint.zero
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        layer.addSublayer(gradientLayer)

        //Horizontal grid pattern setup
        horizontalPatternLayer.anchorPoint = CGPoint.zero
        layer.addSublayer(horizontalPatternLayer)
        
        //Vertical grid pattern setup
        verticalPatternLayer.anchorPoint = CGPoint.zero
        layer.addSublayer(verticalPatternLayer)
        
        //Horizontal lines setup
        horizontalLineLayer.anchorPoint = CGPoint.zero
        horizontalPatternLayer.addSublayer(horizontalLineLayer)
        
        //Vertical Lines setup
        verticalLineLayer.anchorPoint = CGPoint.zero
        verticalPatternLayer.addSublayer(verticalLineLayer)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        //Update gradient
        gradientLayer.frame = layer.bounds
        
        //Update horizontal pattern
        horizontalPatternLayer.frame = layer.bounds
        let hDistance = horizontalPatternLayer.frame.width / CGFloat(horizontalPatternLayer.instanceCount)
        horizontalPatternLayer.instanceTransform = CATransform3DMakeTranslation(hDistance, 0, 0)
        
        //Update vertical lines
        horizontalLineLayer.frame.origin = CGPoint.zero
        horizontalLineLayer.frame.size = CGSize(width: lineWidth, height: layer.bounds.size.height)
        
        //Update vertical pattern
        verticalPatternLayer.frame = layer.bounds
        let vDistance = verticalPatternLayer.frame.height / CGFloat(verticalPatternLayer.instanceCount)
        verticalPatternLayer.instanceTransform = CATransform3DMakeTranslation(0, vDistance, 0)
        
        //Update horizontal lines
        verticalLineLayer.frame.origin = CGPoint.zero
        verticalLineLayer.frame.size = CGSize(width: layer.bounds.size.width, height: lineWidth)
    }
}

