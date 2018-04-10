/**
 This protocol marks classes that can be restored to their original position after a reset
 */
public protocol RestorableNode {
    func backupPosition()
    func restorePosition()
}
