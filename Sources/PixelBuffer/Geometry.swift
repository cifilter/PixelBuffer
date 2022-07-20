#if canImport(UIKit)

import UIKit

extension UIView {
    
    /// A convenience property that indicates that neither size component has an
    /// intrinsic metric for autolayout.
    static let noIntrinsicSize: CGSize = .init(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    
}

#endif
