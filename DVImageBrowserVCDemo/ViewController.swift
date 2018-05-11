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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showImage0(_ sender: UIButton) {
        let images = [UIImage(named: "dnf1"),UIImage(named: "dnf2"),UIImage(named: "dnf3"),UIImage(named: "dnf4"),UIImage(named: "dnf5"),UIImage(named: "dnf6"),UIImage(named: "dnf7")]
        let vc = DVImageBrowserVC()
        vc.images = images
        vc.index = 2
        vc.pageCurrentImg = UIImage(named: "pageCurrentImg")
        vc.pageNoramlImg = UIImage(named: "pageNoramlImg")
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showImage1(_ sender: UIButton) {
        let urls = ["https://image.amall360.com/imageService/uploadFiles/1/dnf1.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf2.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf3.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf4.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf5.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf6.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf7.png"]
        let vc = DVImageBrowserVC()
        vc.images = urls
        vc.index = 2
        vc.pageCurrentImg = UIImage(named: "pageCurrentImg")
        vc.pageNoramlImg = UIImage(named: "pageNoramlImg")
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func showImage2(_ sender: UIButton) {
        let images = [UIImage(named: "dnf1"),UIImage(named: "dnf2"),UIImage(named: "dnf3"),UIImage(named: "dnf4"),UIImage(named: "dnf5"),UIImage(named: "dnf6"),UIImage(named: "dnf7")]
        let vc = DVImageBrowserVC()
        vc.images = images
        vc.index = 2
        vc.pageCurrentImg = UIImage(named: "pageCurrentImg")
        vc.pageNoramlImg = UIImage(named: "pageNoramlImg")
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func showImage3(_ sender: UIButton) {
        let urls = ["https://image.amall360.com/imageService/uploadFiles/1/dnf1.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf2.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf3.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf5.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf6.png",
                    "https://image.amall360.com/imageService/uploadFiles/1/dnf7.png"]
        let vc = DVImageBrowserVC()
        vc.images = urls
        vc.index = 2
        vc.pageCurrentImg = UIImage(named: "pageCurrentImg")
        vc.pageNoramlImg = UIImage(named: "pageNoramlImg")
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension ViewController: DVImageBrowserVCDelegate {
    
    func imageBrowserVC(_ target: DVImageBrowserVC, deleteImgAt imageIndex: Int) {
        print("删除方法")
    }
    
    func imageBrowserVC(_ target: DVImageBrowserVC, longPressAt imageIndex: Int) {
        let vc = DVActionSheetVC()
        vc.footerTitle = "取消"
        vc.moreButtonTitles = ["分享到","识别图中的二维码","收藏","保存图片","编辑"]
        target.present(vc, animated: true, completion: nil)
    }
    
}

