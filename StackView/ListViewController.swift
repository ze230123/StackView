//
//  ListViewController.swift
//  StackView
//
//  Created by 张泽群 on 2022/2/24.
//

import UIKit
import Views
import Refresh

class ListViewController: UIViewController, Nestedable {
    var isScroll: Bool {
        return true
    }

    var contentSize: CGSize {
        return layout.collectionViewContentSize
    }

    var contentOffset: CGPoint {
        get {
            return collectionView.contentOffset
        }
        set {
            collectionView.contentOffset = newValue
        }
    }

    var contentInset: UIEdgeInsets {
        return collectionView.contentInset
    }

    var intrinsicContentSize: CGSize {
        return CGSize(width: Screen.width, height: 600)
    }

    var isHidden: Bool {
        get {
            return view.isHidden
        }
        set {
            view.isHidden = newValue
        }
    }

    var frame: CGRect {
        get {
            return view.frame
        }
        set {
            view.frame = newValue
        }
    }

    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!

    private var sizeObservation: NSKeyValueObservation?

    init() {
        super.init(nibName: "ListViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layout.itemSize = CGSize(width: (Screen.width - 32 - 10) / 2, height: 225)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        collectionView.registerCell(ListCell.self)

        sizeObservation = layout.observe(\.collectionViewContentSize) { [weak self] _, _ in
//            self?.contentSizeDidChanged?()
        }

//        let footerView = RefreshFooterView {
//            print("重新请求")
//        }
//
//        collectionView.rf.footer = RefreshFooter(view: footerView) {
//            print("上拉加载")
//        }
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as ListCell
        cell.configure(item: "\(indexPath.item)")
        return cell
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
