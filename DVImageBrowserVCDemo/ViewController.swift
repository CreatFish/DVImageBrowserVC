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
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "首页"
        self.navigationItem.titleView = label
        
//        var outCount: UInt32 = 0
//        let vars = class_copyIvarList(self.navigationController?.navigationBar.classForCoder, &outCount)
//        for i in 0..<outCount {
//            let ivar = vars?[Int(i)]
//            let ivarName = ivar_getName(ivar)
//            if ivarName != nil {
//                let nName = String(cString: ivarName!)
//                print(nName)
//            }
//        }
        var outCount: UInt32 = 0
        let methods = class_copyMethodList(self.navigationController?.classForCoder, &outCount)
        for i in 0..<outCount {
            let method = methods?[Int(i)]
            let methodName = method_getName(method)
            if methodName != nil {
                print(NSStringFromSelector(methodName!))
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.navigationController?.navigationBar.transform)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showImage0(_ sender: UIButton) {
        let images = [UIImage(named: "dnf1"),UIImage(named: "dnf2"),UIImage(named: "dnf3"),UIImage(named: "dnf4"),UIImage(named: "dnf5"),UIImage(named: "dnf6"),UIImage(named: "dnf7")]
        let vc = DVImageBrowserVC.show(target: self, transitionType: DVImageVCTransitionType.push, images: images, index: 0, deleteBlock: nil)
        vc.pageCurrentImg = UIImage(named: "pageCurrentImg")
        vc.pageNoramlImg = UIImage(named: "pageNoramlImg")
    }
    
    @IBAction func showImage1(_ sender: UIButton) {
        let urls = ["https://image.amall360.com/imageService/uploadFiles/1/dnf1.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf2.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf3.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf4.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf5.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf6.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf7.png"]
        let vc = DVImageBrowserVC.show(target: self, transitionType: DVImageVCTransitionType.push, images: urls, index: 1) { (index) in
            
        }
        vc.pageCurrentImg = UIImage(named: "pageCurrentImg")
        vc.pageNoramlImg = UIImage(named: "pageNoramlImg")
    }
    
    @IBAction func showImage2(_ sender: UIButton) {
        let images = [UIImage(named: "dnf1"),UIImage(named: "dnf2"),UIImage(named: "dnf3"),UIImage(named: "dnf4"),UIImage(named: "dnf5"),UIImage(named: "dnf6"),UIImage(named: "dnf7")]
        let vc = DVImageBrowserVC.show(target: self, transitionType: DVImageVCTransitionType.modal, images: images, index: 2, deleteBlock: nil)
        vc.pageCurrentImg = UIImage(named: "pageCurrentImg")
        vc.pageNoramlImg = UIImage(named: "pageNoramlImg")
    }

    @IBAction func showImage3(_ sender: UIButton) {
        let urls = ["https://image.amall360.com/imageService/uploadFiles/1/dnf1.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf2.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf3.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf5.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf6.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf7.png"]
        let vc = DVImageBrowserVC.show(target: self, transitionType: DVImageVCTransitionType.modal, images: urls, index: 3) { (index) in
            
        }
        vc.pageCurrentImg = UIImage(named: "pageCurrentImg")
        vc.pageNoramlImg = UIImage(named: "pageNoramlImg")
    }
    
}

