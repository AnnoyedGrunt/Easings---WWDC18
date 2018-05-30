import Foundation
import UIKit

/**
 This view controller controls the behaviour of the following views:
 a) A basic view that works as a background
 b) A stack view that layouts out the animation background view and the curve editor view
 c) The animation background view which contains the animated UICircleView
 d) Said UICircleView, animatedCircleView, which receives scale and color animations.
 e) A curve editor view.
 */

public class EasingViewController: UIViewController, UICurveEditorViewDelegate {
    public var curveEditor: UICurveEditorView!
    public var animationBackgroundView: UIView!
    public var animatedCircleView: UICircleView!
    var stackView: UIStackView!
    
    public var animationDuration: CFTimeInterval = 0.0    
    public var startColor: CGColor = UIColor.white.cgColor
    public var endColor: CGColor = UIColor.white.cgColor
    
    public override func loadView() {
        super.loadView()

        view = UIView()
        
        stackView = UIStackView(frame: view.bounds)
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        view.addSubview(stackView)

        animationBackgroundView = UIView()
        
        animatedCircleView = UICircleView(radius: 0, draggable: false) //The radius is unimportant as constraints will be applied later
        animationBackgroundView.addSubview(animatedCircleView)
        
        stackView.addArrangedSubview(animationBackgroundView)
        
        curveEditor = UICurveEditorView()
        curveEditor.delegate = self
        stackView.addArrangedSubview(curveEditor)

        //Setting up stack view constraints
        let fillRatio: (horizontal: CGFloat, vertical: CGFloat) = (0.9, 0.9) //The stack view will not fully fill its parent view
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: fillRatio.horizontal).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: fillRatio.vertical).isActive = true
        
        //Setting up animated circle constraints
        let relativeCircleRadius: CGFloat = 0.9 //The circle is going to expand to fill as much space as possible in its unscaled form.
        
        animatedCircleView.translatesAutoresizingMaskIntoConstraints = false
        animatedCircleView.centerXAnchor.constraint(equalTo: animationBackgroundView.centerXAnchor).isActive = true
        animatedCircleView.centerYAnchor.constraint(equalTo: animationBackgroundView.centerYAnchor).isActive = true
        animatedCircleView.widthAnchor.constraint(equalTo: animationBackgroundView.widthAnchor, multiplier: relativeCircleRadius).isActive = true
        animatedCircleView.heightAnchor.constraint(equalTo: animationBackgroundView.heightAnchor, multiplier: relativeCircleRadius).isActive = true
    }
    
    public override func viewDidLayoutSubviews() {
        stopAnimation()
        if view.bounds.size.width > view.bounds.size.height {
            stackView.axis = .horizontal
            stackView.insertArrangedSubview(curveEditor, at: 0) //The curve editor must be placed on the left when the view is in landscape
        } else {
            stackView.axis = .vertical
            stackView.insertArrangedSubview(animationBackgroundView, at: 0) //The curve editor must be placed on the bottom (and, reciprocally, the content view on top) when the view is vertical.
        }
    }
    
    let scaleKey = "transform.scale"
    let colorKey = "fillColor"
    
    func playAnimation() {
        let repeats = Float.infinity
        
        let scaleAnim = CABasicAnimation(keyPath: scaleKey)
        scaleAnim.fromValue = 0.5
        scaleAnim.toValue = 1
        scaleAnim.repeatCount = repeats
        scaleAnim.duration = animationDuration
        scaleAnim.timingFunction = curveEditor.getTimingFunction()
        animatedCircleView.layer.add(scaleAnim, forKey: scaleKey)
        
        let colorAnim = CABasicAnimation(keyPath: colorKey)
        colorAnim.fromValue = startColor
        colorAnim.toValue = endColor
        colorAnim.repeatCount = repeats
        colorAnim.duration = animationDuration
        colorAnim.timingFunction = curveEditor.getTimingFunction()
        animatedCircleView.contentLayer.add(colorAnim, forKey: colorKey)
        
        curveEditor.playAnimation(duration: animationDuration, repeats: repeats)
    }
    
    func stopAnimation() {
        animatedCircleView.contentLayer.removeAllAnimations()
        animatedCircleView.layer.removeAllAnimations()
        curveEditor.stopAnimation()
    }
    
    public func curveWillChange(_ sender: UICurveEditorView) {
       stopAnimation()
    }
    
    public func curveDidChange(_ sender: UICurveEditorView) {
        playAnimation()
    }
}
