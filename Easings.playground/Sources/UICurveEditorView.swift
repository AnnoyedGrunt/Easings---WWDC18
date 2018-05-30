import Foundation
import UIKit

/**
 Composite view that allows for the editing of a cubic bezier curve with start and end points being the bottom left and top right corners of the view itself. Said curve can then be used as a timing function.
 */
public class UICurveEditorView: UIView {
    public let leftHandle: UICircleView
    public let leftHandleConnector: UIEditableCurveView
    public let rightHandle: UICircleView
    public let rightHandleConnector: UIEditableCurveView
    public let graph: UIChartView
    public let curve: UIEditableCurveView
    public let animationHandle: UICircleView
    public weak var delegate: UICurveEditorViewDelegate?
    
    public override init(frame: CGRect) {
        leftHandle = UICircleView(radius: 32, draggable: true)
        leftHandleConnector = UIEditableCurveView()
        rightHandle = UICircleView(radius: 32, draggable: true)
        rightHandleConnector = UIEditableCurveView()
        graph = UIChartView()
        curve = UIEditableCurveView()
        
        animationHandle = UICircleView(radius: 16, draggable: false)
        animationHandle.isHidden = true
        
        super.init(frame: frame)
        
        addSubview(graph)
        addSubview(leftHandleConnector)
        addSubview(rightHandleConnector)
        addSubview(curve)
        addSubview(animationHandle)
        addSubview(leftHandle)
        addSubview(rightHandle)
        
        
        leftHandle.panGestureRecognizer?.addTarget(self, action: #selector(handleDidChange(_ :)))
        rightHandle.panGestureRecognizer?.addTarget(self, action: #selector(handleDidChange(_ :)))
        
        curve.startPoint = CGPoint(x: 0, y: 1)
        curve.startControl = CGPoint(x: 0.25, y: 0.25)
        curve.endPoint = CGPoint(x: 1, y: 0)
        curve.endControl = CGPoint(x: 0.75, y: 0.75)
        alignHandles()
        
        //Setting up fill constraints for the graph and the curves.
        let views: [UIView] = [graph, curve, leftHandleConnector, rightHandleConnector]
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) has not been implemented yet.")
    }
    
    @objc public func handleDidChange(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began {
            delegate?.curveWillChange(self)
        }
        
        let centerInBounds = sender.view!.center
        let normalizedCenter = CGPoint(x: centerInBounds.x / bounds.width, y: centerInBounds.y / bounds.height)
        if sender.view === leftHandle {
            if curve.startControl != normalizedCenter {
                curve.startControl = normalizedCenter
                leftHandleConnector.setToLine(start: curve.startPoint, end: normalizedCenter)
            }
        } else if sender.view === rightHandle {
            if curve.endControl != normalizedCenter {
                curve.endControl = normalizedCenter
                rightHandleConnector.setToLine(start: curve.endPoint, end: normalizedCenter)
            }
        }
        
        if sender.state == .ended {
            delegate?.curveDidChange(self)
        }
    }
    
    public func playAnimation(duration: CFTimeInterval, repeats: Float) {
        let key = "position"
        let curveAnimation = CAKeyframeAnimation(keyPath: key)
        curveAnimation.path = curve.path
        curveAnimation.timingFunctions = [getTimingFunction()]
        curveAnimation.duration = duration
        curveAnimation.repeatCount = repeats
        
        animationHandle.layer.add(curveAnimation, forKey: key)
        animationHandle.isHidden = false
    }
    
    public func stopAnimation() {
        animationHandle.layer.removeAllAnimations()
        animationHandle.isHidden = true
    }
    
    public func alignHandles() {
        leftHandle.center = curve.startControl * bounds.size
        rightHandle.center = curve.endControl * bounds.size
        leftHandleConnector.setToLine(start: curve.startPoint, end: curve.startControl)
        rightHandleConnector.setToLine(start: curve.endPoint, end: curve.endControl)
    }
    
    public func getTimingFunction() -> CAMediaTimingFunction {
        let c1x = Float(curve.startControl.x)
        let c1y = 1.0 - Float(curve.startControl.y) //The CAMediaTimingFunction constructor uses a coordinate system with an inverse y direction
        let c2x = Float(curve.endControl.x)
        let c2y = 1.0 - Float(curve.endControl.y) //As above
        
        let timingFunc = CAMediaTimingFunction(controlPoints: c1x, c1y, c2x, c2y)
        return timingFunc
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        alignHandles()
    }
}
