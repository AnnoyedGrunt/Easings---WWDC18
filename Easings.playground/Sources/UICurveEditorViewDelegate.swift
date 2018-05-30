import Foundation

public protocol UICurveEditorViewDelegate: NSObjectProtocol {
    func curveWillChange(_ sender: UICurveEditorView)
    func curveDidChange(_ sender: UICurveEditorView)
}
