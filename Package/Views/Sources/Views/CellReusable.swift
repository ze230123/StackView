//
//  CellReusable.swift
//  
//
//  Created by 张泽群 on 2022/2/25.
//

import UIKit

/// Cell快速注册，获取协议
public protocol CellReusable: AnyObject {
    /// 复用ID
    static var reuseableIdentifier: String {get}
    static var nib: UINib? {get}
}

public extension CellReusable where Self: UITableViewCell {
    static var reuseableIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib? {
        return nil
    }
}

public extension CellReusable where Self: UITableViewHeaderFooterView {
    static var reuseableIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib? {
        return nil
    }
}

public extension CellReusable where Self: UICollectionViewCell {
    static var reuseableIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib? {
        return nil
    }
}

public extension CellReusable where Self: UICollectionReusableView {
    static var reuseableIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib? {
        return nil
    }
}

/// Cell配置数据协议
public protocol CellConfigurable: CellReusable {
    associatedtype T
    func configure(item: T)
}

public extension UICollectionView {
    // MARK: - 注册
    /// 注册cell
    func registerCell<C: UICollectionViewCell>(_ cell: C.Type) where C: CellConfigurable {
        if let nib = C.nib {
            register(nib, forCellWithReuseIdentifier: C.reuseableIdentifier)
        } else {
            register(cell, forCellWithReuseIdentifier: C.reuseableIdentifier)
        }
    }

    /// 注册header
    func registerHeaderView<C: UICollectionReusableView>(_ reusableView: C.Type) where C: CellConfigurable {
        if let nib = C.nib {
            register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: C.reuseableIdentifier)
        } else {
            register(reusableView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: C.reuseableIdentifier)
        }
    }

    /// 注册footer
    func registerFooterView<C: UICollectionReusableView>(_ reusableView: C.Type) where C: CellConfigurable {
        if let nib = C.nib {
            register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: C.reuseableIdentifier)
        } else {
            register(reusableView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: C.reuseableIdentifier)
        }
    }

    // MARK: - 复用
    /// 复用cell
    func dequeReusableCell<C: UICollectionViewCell>(indexPath: IndexPath) -> C where C: CellConfigurable {
        return dequeueReusableCell(withReuseIdentifier: C.reuseableIdentifier, for: indexPath) as! C
    }

    /// 复用header
    func dequeReusableHeaderView<C: UICollectionReusableView>(indexPath: IndexPath) -> C where C: CellConfigurable {
        let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: C.reuseableIdentifier, for: indexPath) as! C
        return header
    }

    /// 复用footer
    func dequeReusableFooterView<C: UICollectionReusableView>(indexPath: IndexPath) -> C where C: CellConfigurable {
        let footer = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: C.reuseableIdentifier, for: indexPath) as! C
        return footer
    }
}
