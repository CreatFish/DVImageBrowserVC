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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showImage0(_ sender: UIButton) {
        let images = [UIImage(named: "dnf1"),UIImage(named: "dnf2"),UIImage(named: "dnf3"),UIImage(named: "dnf4"),UIImage(named: "dnf5"),UIImage(named: "dnf6"),UIImage(named: "dnf7")]
        DVImageBrowserVC.show(target: self, transitionType: DVImageVCTransitionType.push, images: images, index: 0, deleteBlock: nil)
    }
    
    @IBAction func showImage1(_ sender: UIButton) {
        let urls = ["https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf1.imageset/dnf1.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf2.imageset/dnf2.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf3.imageset/dnf3.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf4.imageset/dnf4.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf5.imageset/dnf5.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf6.imageset/dnf6.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf7.imageset/dnf7.png"]
        DVImageBrowserVC.show(target: self, transitionType: DVImageVCTransitionType.push, images: urls, index: 1) { (index) in
            
        }
    }
    
    @IBAction func showImage2(_ sender: UIButton) {
        let images = [UIImage(named: "dnf1"),UIImage(named: "dnf2"),UIImage(named: "dnf3"),UIImage(named: "dnf4"),UIImage(named: "dnf5"),UIImage(named: "dnf6"),UIImage(named: "dnf7")]
        DVImageBrowserVC.show(target: self, transitionType: DVImageVCTransitionType.modal, images: images, index: 2, deleteBlock: nil)
    }

    @IBAction func showImage3(_ sender: UIButton) {
        let urls = ["https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf1.imageset/dnf1.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf2.imageset/dnf2.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf3.imageset/dnf3.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf4.imageset/dnf4.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf5.imageset/dnf5.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf6.imageset/dnf6.png","https://github.com/CreatFish/DVImageBrowserVC/blob/master/DVImageBrowserVCDemo/Assets.xcassets/dnf7.imageset/dnf7.png"]
        DVImageBrowserVC.show(target: self, transitionType: DVImageVCTransitionType.modal, images: urls, index: 3) { (index) in
            
        }
    }
    
}

