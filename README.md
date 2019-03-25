# DVImageBrowserVC
一个图片浏览器,使用简单,因为需要下载网络图片，所以需要项目中加入SDWebImage，耦合性相对还好，支持modal或者push转场，一行代码搞定图片浏览，同时支持删除操作与长按手势。

  运行效果    
  
  <img src="https://github.com/CreatFish/DVImageBrowserVC/blob/master/gif/saQhOpdAJr.gif">    
  
  ## 一. Installation 安装
  手动导入：将DVImageBrowserVC文件夹导入项目中，需要事先导入SDWebImage。推荐与DVActionSheetVC搭配使用长按手势体验更佳。
  
  ## 二. Example 例子
  ```
let images = [UIImage(named: "dnf1"),UIImage(named: "dnf2"),UIImage(named: "dnf3"),UIImage(named: "dnf4"),UIImage(named: "dnf5"),UIImage(named: "dnf6"),UIImage(named: "dnf7")]
let vc = DVImageBrowserVC()
vc.images = images
// 当前图片的索引
vc.index = 2
//pageControl当前索引的背景图片
vc.pageCurrentImg = UIImage(named: "pageCurrentImg")
//pageControl普通状态下的背景图片
vc.pageNoramlImg = UIImage(named: "pageNoramlImg")
vc.delegate = self
self.navigationController?.pushViewController(vc, animated: true)

extension ViewController: DVImageBrowserVCDelegate {

    func imageBrowserVC(_ target: DVImageBrowserVC, deleteImgAt imageIndex: Int) {
        print("删除方法")
    }

    func imageBrowserVC(_ target: DVImageBrowserVC, longPressAt imageIndex: Int) {
        //与DVActionSheetVC搭配使用长按手势体验更佳
        let vc = DVActionSheetVC()
        vc.footerTitle = "取消"
        vc.moreButtonTitles = ["分享到","识别图中的二维码","收藏","保存图片","编辑"]
        target.present(vc, animated: true, completion: nil)
    }

}
```
  
  
  ## 三. Requirements 要求
   iOS8及以上系统可使用. ARC环境. 
   
   ## 四. More 更多 
   如果你发现了bug,请与我联系，邮箱:654070281@qq.com
