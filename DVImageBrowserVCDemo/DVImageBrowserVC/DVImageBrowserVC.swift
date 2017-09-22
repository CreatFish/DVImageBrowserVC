//
//  DVImageBrowserVC.swift
//  DVImageBrowserVCDemo
//
//  Created by LIHUA LEI on 2017/8/29.
//  Copyright © 2017年 david. All rights reserved.
//

enum DVImageVCTransitionType {
    case modal
    case push
}

import UIKit

class DVImageBrowserVC: UIViewController {
    
    /// 有导航栏存在时，设置了也无效，需要设置self.navigationController?.navigationBar.barStyle = UIBarStyle.black才能改成白色
    /// 这里是为了防止状态栏文字是黑色影响视觉效果
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
    
    /// 删除按钮
    fileprivate lazy var deleteBtn: UIButton! = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "DVIBVC_Delete@2x"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(self.deleteImage), for: UIControlEvents.touchUpInside)
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
    
    fileprivate lazy var imageCollection: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        /// 竖直方向的间距
        layout.minimumLineSpacing = 0
        /// 水平方向的间距
        layout.minimumInteritemSpacing = 0
        /// 设置为水平滚动
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collection: UICollectionView! = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.black
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.register(DVImageCell.self, forCellWithReuseIdentifier: "DVImageCell")

        collection.delegate = self
        collection.dataSource = self
        
        return collection
    }()
    
    fileprivate lazy var pageControl: UIPageControl! = {
        let page = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-50, width: UIScreen.main.bounds.width, height: 20))
        page.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.2)
        page.currentPageIndicatorTintColor = UIColor.white
        
        return page
    }()
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
    
    /// 图片集合，可以传入图片数组或者字符串数组，其他无效
    fileprivate var images: [Any]? {
        didSet {
            self.imageCollection.reloadData()
            self.pageControl.numberOfPages = images?.count ?? 0
            if self.index >= images?.count ?? 1 {
                self.index = self.index - 1
            } else if self.index < 0 {
                self.index = 0
            }
            self.imageCollection.setContentOffset(CGPoint(x: (CGFloat)(self.index)*UIScreen.main.bounds.width, y: 0), animated: false)
        }
    }
    /// 当前正在显示的图片的索引
    fileprivate var index: Int! {
        didSet {
            self.pageControl.currentPage = index
            self.titleLabel.text = "\((self.index ?? 0) + 1)/\(self.images?.count ?? 0)"
        }
    }
    /// 删除block
    fileprivate var deleteBlock: ((Int)->Void)? {
        didSet {
            if deleteBlock == nil {
                self.deleteBtn.isHidden = true
            } else {
                self.deleteBtn.isHidden = false
            }
        }
    }
    /// 转场方式
    fileprivate var transitionType = DVImageVCTransitionType.modal
    
    /// 是否隐藏导航栏与状态栏 push转场时，点击屏幕隐藏或者显示导航栏
    fileprivate var hiddenNav = false {
        didSet {
            if self.transitionType == DVImageVCTransitionType.modal {
                UIView.animate(withDuration: 0.4, animations: {
                    self.setNeedsStatusBarAppearanceUpdate()
                })
            } else if self.transitionType == DVImageVCTransitionType.push {
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
                UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    bar.transform = tran
                    self.setNeedsStatusBarAppearanceUpdate()
                }, completion: nil)
            }
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            return UIStatusBarAnimation.slide
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return hiddenNav
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
            self.deleteBtn.setImage(deleteBtnImage, for: UIControlState.normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hiddenNav = true
    }
    
    /// 原先导航控制器右滑是否enable
    var popGestureRecognizer: Bool?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if self.transitionType == DVImageVCTransitionType.push {
//            /// 暂时关闭导航控制器的右滑，否则会有一个显示上的bug，经测试，微信上也存在此显示bug,呆修复
//            popGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer?.isEnabled
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.transitionType == DVImageVCTransitionType.push {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = popGestureRecognizer ?? true
            guard self.navigationController != nil else {
                return
            }
            let bar = self.navigationController!.navigationBar
            var tran = bar.transform
            tran = CGAffineTransform.identity
            bar.transform = tran
        } else if self.transitionType == DVImageVCTransitionType.modal {
            hiddenNav = false
        }
    }
    
    /*!
     显示图片浏览器，支持modal与push两种转场
     
     @param target                  控制器，传入上个界面的控制
     @param transitionType          转场方式，modal或者push
     @param images                  图片数组，可以传入uimage数组或者string数组
     @param index                   当前索引，传入需要当前显示图片的索引
     @param deleteBlock             删除回调，传入nil时，不会显示删除按钮
     
     @discussion
     */
    class func show(target: UIViewController!, transitionType: DVImageVCTransitionType, images: [Any]?, index: Int, deleteBlock: ((Int)->Void)?) -> DVImageBrowserVC {
        let vc = DVImageBrowserVC()
        vc.index = index < 0 ? 0 : index
        vc.images = images
        vc.pageControl.currentPage = vc.index
        vc.deleteBlock = deleteBlock
        vc.transitionType = transitionType
        
        if transitionType == DVImageVCTransitionType.modal {
            target.present(vc, animated: true, completion: nil)
        } else if transitionType == DVImageVCTransitionType.push {
            target.navigationController?.pushViewController(vc, animated: true)
        }
        
        return vc
    }
    
    func setView() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(imageCollection)
        self.view.addSubview(pageControl)
        
        self.navigationItem.titleView = self.titleLabel
        self.titleLabel.text = "\((self.index ?? 0) + 1)/\(self.images?.count ?? 0)"
        if self.transitionType == DVImageVCTransitionType.push {
            deleteBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
            spaceItem.width = -15
            self.navigationItem.rightBarButtonItems = [spaceItem,UIBarButtonItem(customView: deleteBtn)]
        } else if self.transitionType == DVImageVCTransitionType.modal {
            deleteBtn.frame = CGRect(x: UIScreen.main.bounds.width-45, y: 20, width: 30, height: 30)
            self.view.addSubview(deleteBtn)
        }
    }
    
    /// 删除图片
    func deleteImage() {
        self.deleteBlock?(self.index)
        
        var imgs = self.images
        imgs?.remove(at: self.index)
        if imgs?.count ?? 0 <= 0 {
            if self.transitionType == DVImageVCTransitionType.modal {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.images = imgs
            self.titleLabel.text = "\((self.index ?? 0) + 1)/\(self.images?.count ?? 0)"
        }
    }

}

extension DVImageBrowserVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DVImageCell", for: indexPath)
        
        (cell as? DVImageCell)?.image = self.images?[indexPath.row]
        (cell as? DVImageCell)?.singleTapBolck = {
            if self.transitionType == DVImageVCTransitionType.push {
                self.hiddenNav = !self.hiddenNav
            } else if self.transitionType == DVImageVCTransitionType.modal {
                self.dismiss(animated: true, completion: nil)
            }
        }
        (cell as? DVImageCell)?.gestureBlock = {
            if self.transitionType == DVImageVCTransitionType.push && self.hiddenNav == false {
                self.hiddenNav = true
            }
        }
        
        return cell
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if self.transitionType == DVImageVCTransitionType.push && hiddenNav == false {
            hiddenNav = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        self.index = (Int)(offsetX / UIScreen.main.bounds.width)
    }
    
}
