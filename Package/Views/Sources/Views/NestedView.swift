//
//  NestedView.swift
//  
//
//  Created by 张泽群 on 2022/2/24.
//

import UIKit

public protocol Nestedable: AnyObject {
    /// 内容视图
    var contentView: UIView { get }
    /// 自适应大小
    var intrinsicContentSize: CGSize { get }
    /// 是否隐藏
    var isHidden: Bool { get set }
    /// 内容视图frame
    var frame: CGRect { get set }

    var isScroll: Bool { get }

    var contentSize: CGSize { get }

    var contentOffset: CGPoint { get set }

    var contentInset: UIEdgeInsets { get }

//    /// 滚动视图
//    var scrollView: UIScrollView? { get }
//    /// 内容大小发生变化
//    var contentSizeDidChanged: (() -> Void)? { get set }
}

public extension Nestedable where Self: UIView {
    var contentView: UIView {
        return self
    }

    var contentSize: CGSize {
        return .zero
    }

    var isScroll: Bool {
        return false
    }

    var contentInset: UIEdgeInsets {
        return .zero
    }
}

public extension Nestedable where Self: UIViewController {
    var contentView: UIView {
        return view
    }
}

/// 多视图(包含滚动视图)垂直排列，cell可复用
///
/// ArrangedSubview 需实现 intrinsicContentSize，提供一个默认高度
public final class NestedView: UIScrollView {
    private lazy var contentView = UIView()

    private var subviewsInLayoutOrder: [Nestedable] = []

    deinit {
        debugPrint("EGStackView_deinit")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        print("nestedView", safeAreaInsets)

        contentView.frame = bounds
        contentView.bounds = CGRect(origin: contentOffset, size: contentView.bounds.size)

        // 整体内容高度
        var offsetyOfCurrentSubview: CGFloat = 0

        for obj in subviewsInLayoutOrder {
            var subFrame = obj.frame
            if obj.isHidden {
                var frame = obj.frame
                frame.origin.y = offsetyOfCurrentSubview
                frame.origin.x = 0
                frame.size.width = self.contentView.bounds.size.width
                obj.frame = frame

                // Do not set the height to zero. Just don't add the original height to yOffsetOfCurrentSubview.
                // This is to keep the original height when the view is unhidden.
                continue;
            }

            // 如果是滚动视图
            if obj.isScroll {
                var subContentOffset = obj.contentOffset
                if contentOffset.y + safeAreaInsets.top < offsetyOfCurrentSubview {
                    subContentOffset.y = 0
                    subFrame.origin.y = offsetyOfCurrentSubview
                } else {
                    subContentOffset.y = contentOffset.y + safeAreaInsets.top - offsetyOfCurrentSubview
                    subFrame.origin.y = contentOffset.y + safeAreaInsets.top
                }

                let normalHeight = obj.intrinsicContentSize.height
                let remainingBoundsHeight = fmax(bounds.maxY - subFrame.minY, normalHeight)
                let remainingContentHeight = fmax(obj.contentSize.height - subContentOffset.y, normalHeight)

                subFrame.size.height = fmin(remainingBoundsHeight, remainingContentHeight)
                subFrame.size.width = contentView.bounds.width

                obj.frame = subFrame
                obj.contentOffset = subContentOffset

                offsetyOfCurrentSubview += (obj.contentSize.height + obj.contentInset.top + obj.contentInset.bottom)
            } else {
                subFrame.origin.y = offsetyOfCurrentSubview
                subFrame.origin.x = 0
                subFrame.size.width = contentView.bounds.width
                subFrame.size.height = obj.intrinsicContentSize.height
                obj.frame = subFrame

                offsetyOfCurrentSubview += subFrame.size.height
            }
        }

        let minimumContentHeight = bounds.size.height - (contentInset.top + contentInset.bottom)
        let initialContentOffset = contentOffset
        contentSize = CGSize(width: bounds.width, height: fmax(offsetyOfCurrentSubview, minimumContentHeight))

        if initialContentOffset != contentOffset {
            setNeedsLayout()
        }
    }
}

public extension NestedView {
    func addArrangedSubview<Object>(_ obj: Object) where Object: Nestedable {
        contentView.addSubview(obj.contentView)
        subviewsInLayoutOrder.append(obj)
//        obj.contentSizeDidChanged = { [weak self] in
//            self?.setNeedsLayout()
//        }
    }

//    func scrollToView<V>(_ view: V, animated: Bool) where V: Nestedable {
////        guard let subView = subviewsInLayoutOrder.first(where: { $0 == view }) else  { return }
//        var y: CGFloat = 0
//        for subView in subviewsInLayoutOrder {
//            if view == subView {
//                break
//            }
//            if let scrollView = subView.scrollView {
//                 y += scrollView.contentSize.height
//            } else {
//                y += subView.frame.height
//            }
//        }
//        debugPrint("滚动到: ", y)
//        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
//    }

    func reload() {
        setNeedsLayout()
    }
}

private extension NestedView {
    func prepare() {
        addSubview(contentView)
    }
}
