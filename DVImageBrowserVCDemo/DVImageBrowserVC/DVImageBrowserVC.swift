//
//  DVImageBrowserVC.swift
//  DVImageBrowserVCDemo
//
//  Created by LIHUA LEI on 2017/8/29.
//  Copyright © 2017年 david. All rights reserved.
//

// MARK:-   DVImageBrowserVC代理
@objc protocol DVImageBrowserVCDelegate: NSObjectProtocol {
    //  删除代理
    @objc optional func imageBrowserVC(_ target: DVImageBrowserVC, deleteImgAt imageIndex: Int)
    //  长按代理
    @objc optional func imageBrowserVC(_ target: DVImageBrowserVC, longPressAt imageIndex: Int)
    
}

import UIKit

public class DVImageBrowserVC: UIViewController {
    
    var delegate: DVImageBrowserVCDelegate?
    /// 有导航栏存在时，设置了也无效，需要设置self.navigationController?.navigationBar.barStyle = UIBarStyle.black才能改成白色
    /// 这里是为了防止状态栏文字是黑色影响视觉效果
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
    
    /// 删除按钮
    fileprivate lazy var deleteBtn: UIButton! = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "DVIBVC_Delete@2x"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(self.deleteImage), for: UIControl.Event.touchUpInside)
        return btn
    }()
    /// 导航栏标题
    fileprivate lazy var titleLabel: UILabel! = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    /// 显示图片的collection
    fileprivate lazy var imageCollection: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        /// 竖直方向的间距
        layout.minimumLineSpacing = 0
        /// 水平方向的间距
        layout.minimumInteritemSpacing = 0
        /// 设置为水平滚动
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collection: UICollectionView! = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.black
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.register(DVImageCell.self, forCellWithReuseIdentifier: "DVImageCell")
        collection.delegate = self
        collection.dataSource = self
        let longPressGest = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(longPressGest:)))
        longPressGest.minimumPressDuration = 0.3
        longPressGest.allowableMovement = 5.0
        collection.addGestureRecognizer(longPressGest)
        return collection
    }()
    /// pageControl
    fileprivate lazy var pageControl: UIPageControl! = {
        let page = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-50, width: UIScreen.main.bounds.width, height: 20))
        page.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.2)
        page.currentPageIndicatorTintColor = UIColor.white
        
        return page
    }()
    /// 图片集合，可以传入图片数组或者字符串数组，其他无效
    var images: [Any]? {
        didSet {
            self.imageCollection.reloadData()
            self.pageControl.numberOfPages = images?.count ?? 0
        }
    }
    /// pageControl正常的的图片
    var pageNoramlImg: UIImage? {
        didSet {
            self.pageControl.setValue(pageNoramlImg, forKeyPath: "_pageImage")
        }
    }
    /// pageControl当前选中的图片
    var pageCurrentImg: UIImage? {
        didSet {
            self.pageControl.setValue(pageCurrentImg, forKeyPath: "_currentPageImage")
        }
    }
    /// 当前正在显示的图片的索引
    var index: Int! {
        didSet {
            self.pageControl.currentPage = index
            if self.index >= images?.count ?? 1 {
                self.index = self.index - 1
            } else if self.index < 0 {
                self.index = 0
            }
            self.imageCollection.setContentOffset(CGPoint(x: (CGFloat)(self.index)*UIScreen.main.bounds.width, y: 0), animated: false)
            self.titleLabel.text = "\((self.index ?? 0) + 1)/\(self.images?.count ?? 0)"
        }
    }
    /// 是否隐藏导航栏与状态栏 push转场时，点击屏幕隐藏或者显示导航栏
    fileprivate var hiddenNav = false {
        didSet {
            guard self.navigationController != nil else {
                return
            }
            let bar = self.navigationController!.navigationBar
            var tran = bar.transform
            
            if hiddenNav {
                tran.ty = -64
            } else {
                tran = CGAffineTransform.identity
            }
            UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                bar.transform = tran
                self.setNeedsStatusBarAppearanceUpdate()
            }, completion: nil)
        }
    }
    
    /// 导航栏标题颜色
    var titleColor = UIColor.white {
        didSet {
            self.titleLabel.textColor = titleColor
        }
    }

    /// 删除按钮的图片
    var deleteBtnImage: UIImage? {
        didSet {
            self.deleteBtn.setImage(deleteBtnImage, for: UIControl.State.normal)
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setView()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hiddenNav = true
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// 当导航处于屏幕外面时直接右滑让导航栏复位，否则滑出去之后导航栏会消失
        guard self.navigationController != nil else {
            return
        }
        let bar = self.navigationController!.navigationBar
        var tran = bar.transform
        tran = CGAffineTransform.identity
        bar.transform = tran
    }
    
    func setView() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(imageCollection)
        self.view.addSubview(pageControl)
        
        self.navigationItem.titleView = self.titleLabel
        self.titleLabel.text = "\((self.index ?? 0) + 1)/\(self.images?.count ?? 0)"
        let canDelegate = delegate?.responds(to: #selector(delegate?.imageBrowserVC(_:deleteImgAt:))) ?? false
        self.deleteBtn.isHidden = !canDelegate
        if canDelegate {
            if self.navigationController != nil {
                deleteBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
                let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
                spaceItem.width = -15
                self.navigationItem.rightBarButtonItems = [spaceItem,UIBarButtonItem(customView: deleteBtn)]
            } else {
                deleteBtn.frame = CGRect(x: UIScreen.main.bounds.width-45, y: 20, width: 30, height: 30)
                self.view.addSubview(deleteBtn)
            }
        }
    }
    
    /// 删除图片
    @objc func deleteImage() {
        delegate?.imageBrowserVC?(self, deleteImgAt: self.index)
        var imgs = self.images
        imgs?.remove(at: self.index)
        if self.index >= (imgs?.count ?? 0) {
            self.index = (imgs?.count ?? 0) - 1
        }
        if imgs?.count ?? 0 <= 0 {
            if self.navigationController != nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.images = imgs
            self.titleLabel.text = "\((self.index ?? 0) + 1)/\(self.images?.count ?? 0)"
        }
    }
    
    /// 长按手势
    @objc private func longPressAction(longPressGest: UILongPressGestureRecognizer) {
        if longPressGest.state == .began {
            delegate?.imageBrowserVC?(self, longPressAt: self.index)
        }
    }

}

extension DVImageBrowserVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DVImageCell", for: indexPath)
        (cell as? DVImageCell)?.image = self.images?[indexPath.row]
        (cell as? DVImageCell)?.singleTapBolck = {
            if self.navigationController != nil {
                self.hiddenNav = !self.hiddenNav
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        (cell as? DVImageCell)?.gestureBlock = {
            if self.navigationController != nil && self.hiddenNav == false {
                self.hiddenNav = true
            }
        }
        return cell
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if self.navigationController != nil && self.hiddenNav == false {
            hiddenNav = true
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        self.index = (Int)(offsetX / UIScreen.main.bounds.width)
    }
    
}
