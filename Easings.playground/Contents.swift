import UIKit
import PlaygroundSupport

/*:
 ## Easing and curves in animation
 
 Animation is the act of tricking our minds into perceiving movement. Traditionally, this meant drawing many similar images, or taking photos of carefully posed puppets and clay sculptures.
 
 In computer graphics, however, animation is the act of interpolating between two values in a given amount of time using an easing function. If what we are interpolating is a graphical characteristic, such as the shape, color, position or scale of an element, the interpolation will result in an visibile animation.
 
 This playground shows three examples of computer animation. It shows how curves and different tempos can be used to give life to the changes in size, color, and position of simple circles.
 
 ### Easing functions
 Also known as smoothing, timing (like in Apple's own CoreAnimation), tweening or interpolating functions. These functions take take a single parameter (***time***) and output the ***value*** at that point in time. Both time and value are usually normalized so they can be used in a generic way.
 
 Since a function is nothing but a curve it can be represented through a Bezier curve. A Bezier curve is a way to mathematically represent a smooth curve using only four points - a start point, an end point, and two controls.
 
 ## Controls
 Move the handles to make the animations start. Experiment with shapes and see how different curves create different feelings.
  A linear or mostly linear curve does not provide any acceleration or deceleration, making movement seem "lifeless". Steep slopes provide acceleration while horizontal sectors bring the animation close to a stop.
*/

let easingViewController = EasingViewController()
PlaygroundPage.current.liveView = easingViewController

/*:
 ## Customization
 The playground is graphically customizable. Feel free to change it as you please!
 */


//: Background color

easingViewController.view.backgroundColor = #colorLiteral(red: 0.567217648, green: 0.6807430387, blue: 0.7313571572, alpha: 1)

//: Animation settings

easingViewController.animationDuration = 2.0
easingViewController.startColor = #colorLiteral(red: 0.8112578988, green: 0.4018072188, blue: 0.3998268545, alpha: 1)
easingViewController.endColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
easingViewController.animationBackgroundView.backgroundColor = #colorLiteral(red: 0.194658637, green: 0.2497246563, blue: 0.365963757, alpha: 1)

//:These settings change how the graph looks.
let curveEditor: UICurveEditorView = easingViewController.curveEditor

curveEditor.graph.topColor = #colorLiteral(red: 0.1945445836, green: 0.2498588264, blue: 0.361780107, alpha: 1)
curveEditor.graph.bottomColor = #colorLiteral(red: 0.002440408105, green: 0.07483642548, blue: 0.1300551891, alpha: 1)
curveEditor.graph.lineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
curveEditor.graph.lineWidth = 1.0
curveEditor.graph.horizontalLineCount = 10
curveEditor.graph.verticalLineCount = 10

//:These settings change how the curve handles look.

for handle in [curveEditor.leftHandle, curveEditor.rightHandle] {
    handle.fillColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 0)
    handle.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9)
    handle.borderWidth = 5.0
    handle.borderPattern = [20,5]
    handle.spinningDuration = 3
}

//: These settings change how the handle connectors look

for connector in [curveEditor.leftHandleConnector, curveEditor.rightHandleConnector] {
    connector.lineWidth = 5.0
    connector.lineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9)
}

//: These settings change how the actual curve in the graph looks.

curveEditor.curve.lineWidth = 5.0
curveEditor.curve.lineColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
curveEditor.curve.fillColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 0)

//: These settings change how the animation handle looks.

curveEditor.animationHandle.fillColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
curveEditor.animationHandle.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
curveEditor.animationHandle.borderWidth = 0.0
curveEditor.animationHandle.borderPattern = []
curveEditor.animationHandle.spinningDuration = 0.0
