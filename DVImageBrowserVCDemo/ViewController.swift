//
//  ViewController.swift
//  DVImageBrowserVCDemo
//
//  Created by LIHUA LEI on 2017/8/29.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "首页"
        self.navigationItem.titleView = label
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showImage(_ sender: UIButton) {
//        let images = [UIImage(named: "dnf1"),UIImage(named: "dnf2"),UIImage(named: "dnf3"),UIImage(named: "dnf4"),UIImage(named: "dnf5"),UIImage(named: "dnf6"),UIImage(named: "dnf7")]
        let urls = ["http://img.52cos.cn/upload/photo/15035732852rq6.png","http://img.52cos.cn/upload/photo/1503573285h5wc.png","http://img.52cos.cn/upload/photo/1503573285g34z.png"]
        DVImageBrowserVC.show(target: self, transitionType: DVImageVCTransitionType.push, images: urls, index: 1) { (index) in
            
        }
//        DVImageBrowserVC.show(target: self, transitionType: DVImageVCTransitionType.modal, images: urls, index: 2, deleteBlock: nil)
    }

}

