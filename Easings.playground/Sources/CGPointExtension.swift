import Foundation
import UIKit

public extension CGPoint {
    
    //This operator overload allows for the conversion of a normalized CGPoint to actual coordinates in a quick way.
    static func *(lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.x * rhs.width, y: lhs.y * rhs.height)
    }
}
