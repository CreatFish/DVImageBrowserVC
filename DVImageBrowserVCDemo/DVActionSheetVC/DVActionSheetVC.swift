//
//  DVActionSheetVC.swift
//  DVActionSheetDemo
//
//  Created by David Yu on 2017/8/28.
//  Copyright © 2017年 david. All rights reserved.
//

protocol DVActionSheetVCDelegate {
    func dvActionSheetVC(_ actionSheetVC: DVActionSheetVC, clickedButtonAt buttonIndex: Int)
}

import UIKit

//  背景颜色
let kActionSheetBGColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
//  字体颜色
let kActionSheetTextColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
//  actionBtn高度
let kActionSheetCellHeight: CGFloat = 55

class DVActionSheetVC: UIViewController {

    var delegate: DVActionSheetVCDelegate?
    lazy var actionSheet: UITableView! = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.addSubview(table)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = kActionSheetBGColor
        table.delegate = self
        table.dataSource = self
        table.bounces = false
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.register(DVActionCell.classForCoder(), forCellReuseIdentifier: "DVActionCell")
        table.register(DVActionFooter.classForCoder(), forHeaderFooterViewReuseIdentifier: "DVActionFooter")
        table.register(DVActionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "DVActionHeader")
        return table
    }()
    
    /*!
     完成回调
     
     @discussion 可使用代理或者block，若实现了block将不会执行代理
     */
    var finishSelect: ((UInt32)->Void)?
    
    var headerTitleColor: UIColor = UIColor.lightGray {
        didSet {
            reloadActionSheet()
        }
    }
    var cellTitleColor: UIColor = kActionSheetTextColor {
        didSet {
            reloadActionSheet()
        }
    }
    var footerTitleColor: UIColor = kActionSheetTextColor {
        didSet {
            reloadActionSheet()
        }
    }
    /// 取消按钮的title，默认为取消
    var footerTitle: String? {
        didSet {
            reloadActionSheet()
        }
    }
    /// 标题按钮的title
    var headerTitle: String? {
        didSet {
            reloadActionSheet()
        }
    }
    /// actionSheet的标题集合
    var moreButtonTitles: [String] = [] {
        didSet {
            reloadActionSheet()
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
    
    func setView() {
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        self.modalPresentationStyle = UIModalPresentationStyle.custom
        self.transitioningDelegate = self
    }
    
    /*!
     计算actionSheet高度
     
     @discussion 大于屏幕高度减去状态栏高度时让table高度等于屏幕高度
     */
    func reloadActionSheet() {
        var height: CGFloat = 0
        height = height + (headerTitle != nil ? kActionSheetCellHeight : 0)
        height = height + (footerTitle != nil ? kActionSheetCellHeight + 3 : 0)
        height = height + kActionSheetCellHeight*CGFloat(moreButtonTitles.count)
        let maxHeight: CGFloat = (UIScreen.main.bounds.height == 812) ? (UIScreen.main.bounds.height - 44) : (UIScreen.main.bounds.height - 20)
        if height > maxHeight {
            height = maxHeight
        }
        actionSheet.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        actionSheet.center = CGPoint(x: UIScreen.main.bounds.width*0.5, y: UIScreen.main.bounds.height-actionSheet.bounds.height*0.5)
        actionSheet.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func hide() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension DVActionSheetVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreButtonTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerTitle != nil ? kActionSheetCellHeight : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kActionSheetCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerTitle != nil ? (kActionSheetCellHeight + 3) : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if headerTitle != nil {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DVActionHeader") as! DVActionHeader
            header.titleColor = headerTitleColor
            header.title = headerTitle
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if footerTitle != nil {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DVActionFooter") as! DVActionFooter
            footer.titleColor = footerTitleColor
            footer.title = footerTitle
            footer.label.addTarget(self, action: #selector(self.hide), for: UIControlEvents.touchUpInside)
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DVActionCell") as! DVActionCell
        cell.titleColor = cellTitleColor
        cell.title = moreButtonTitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            if self.finishSelect != nil {
                self.finishSelect?(UInt32(indexPath.row))
            } else {
                self.delegate?.dvActionSheetVC(self, clickedButtonAt: indexPath.row)
            }
        }
    }
}

/// 转场动画类型
enum DVPresentAnimatorType {
    case present
    case dismiss
}

///转场动画代理
extension DVActionSheetVC: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return actionSheetVCPresentAnimator(withType: DVPresentAnimatorType.present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return actionSheetVCPresentAnimator(withType: DVPresentAnimatorType.dismiss)
    }
}

/// 模态转场动画
class actionSheetVCPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var type: DVPresentAnimatorType = DVPresentAnimatorType.present
    
    init(withType: DVPresentAnimatorType) {
        super.init()
        self.type = withType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case DVPresentAnimatorType.present:
            self.presentAnimation(transitionContext: transitionContext)
        case DVPresentAnimatorType.dismiss:
            self.dismissAnimation(transitionContext: transitionContext)
        }
    }
    
    //present动画
    func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? DVActionSheetVC
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        //containerView是动画过程中提供的暂时容器。
        let containerView = transitionContext.containerView
        if toView != nil {
            containerView.addSubview(toView!)
            toView!.backgroundColor = UIColor.black.withAlphaComponent(0)
            let transitionDuration = self.transitionDuration(using: transitionContext)
            let actionSheet = toVC?.actionSheet
            let transform = CGAffineTransform(translationX: 0, y: actionSheet?.bounds.height ?? 0)
            actionSheet?.transform = transform
            toView?.backgroundColor = UIColor.black.withAlphaComponent(0)
            UIView.animate(withDuration: transitionDuration, animations: {
                toView?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                actionSheet?.transform = CGAffineTransform.identity
            }, completion: { (bool) in
                let wasCancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!wasCancelled)
            })
        }
    }
    
    //dismiss动画
    func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? DVActionSheetVC
        if fromView != nil {
            let actionSheet = fromVC?.actionSheet
            let transitionDuration = self.transitionDuration(using: transitionContext)
            UIView.animate(withDuration: transitionDuration, animations: {
                let transform = CGAffineTransform(translationX: actionSheet?.transform.tx ?? 0, y: actionSheet?.bounds.height ?? 0)
                actionSheet?.transform = transform
                fromView?.backgroundColor = UIColor.black.withAlphaComponent(0)
            }, completion: { (bool) in
                let wasCancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!wasCancelled)
            })
        }
    }
    
}

/*!
 ActionSheet的Cell
 
 @discussion 用来显示各类选项
 */
class DVActionCell: UITableViewCell {
    var title: String? {
        didSet {
            self.label.text = title
        }
    }
    var titleColor: UIColor? {
        didSet {
            label.textColor = titleColor
        }
    }
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kActionSheetCellHeight)
        label.backgroundColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(label)
        
        let subLayer = CAShapeLayer()
        subLayer.strokeColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1).cgColor
        subLayer.lineWidth = (1 / UIScreen.main.scale)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0-((1 / UIScreen.main.scale) / 2), y: kActionSheetCellHeight))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width-((1 / UIScreen.main.scale) / 2), y: kActionSheetCellHeight))
        subLayer.path = path.cgPath
        self.contentView.layer.addSublayer(subLayer)
        
        self.selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kActionSheetCellHeight))
        self.selectedBackgroundView?.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 0.9)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/*!
 ActionSheet的Header
 
 @discussion 用来显示标题之类
 */
class DVActionHeader: UITableViewHeaderFooterView {
    var title: String? {
        didSet {
            label.text = title
        }
    }
    var titleColor: UIColor? {
        didSet {
            label.textColor = titleColor
        }
    }
    var label = UILabel()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kActionSheetCellHeight))
        label.backgroundColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(label)
        
        let subLayer = CAShapeLayer()
        subLayer.strokeColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1).cgColor
        subLayer.lineWidth = (1 / UIScreen.main.scale)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0-((1 / UIScreen.main.scale) / 2), y: kActionSheetCellHeight))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width-((1 / UIScreen.main.scale) / 2), y: kActionSheetCellHeight))
        subLayer.path = path.cgPath
        self.contentView.layer.addSublayer(subLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*!
 ActionSheet的Footer
 
 @discussion 用来显示取消之类的操作
 */
class DVActionFooter: UITableViewHeaderFooterView {
    var title: String? {
        didSet {
            label.setTitle(title, for: UIControlState.normal)
        }
    }
    var titleColor: UIColor? {
        didSet {
            label.setTitleColor(titleColor, for: UIControlState.normal)
        }
    }
    var label = UIButton()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        
        let subLayer = CALayer()
        subLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 3)
        subLayer.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 0.9).cgColor
        self.contentView.layer.addSublayer(subLayer)
        
        label.frame = CGRect(x: 0, y: 3, width: UIScreen.main.bounds.width, height: kActionSheetCellHeight)
        label.backgroundColor = UIColor.white
        label.setBackgroundImage(UIImage.ImageFromColor(UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 0.9), frame: label.bounds), for: UIControlState.highlighted)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        label.titleLabel?.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    /*!
     通过颜色来生成图片
     
     @discussion
     */
    static func ImageFromColor(_ color: UIColor, frame: CGRect) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
