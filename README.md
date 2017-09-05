# DVImageBrowserVC
一个图片浏览器,使用简单,因为需要下载网络图片，所以需要项目中加入SDWebImage，耦合性相对还好，支持modal或者push转场，一行代码搞定图片浏览，同时支持删除操作。    

  运行效果    
  
  <img src="https://github.com/CreatFish/DVImageBrowserVC/blob/master/gif/saQhOpdAJr.gif">    
  
  ## 一. Installation 安装
  手动导入：将DVImageBrowserVC文件夹导入项目中，需要事先导入SDWebImage。如果状态栏显示异常,需要在项目的info.plist新增View controller-based status bar appearance,并设置成true    
  
  ## 二. Example 例子    
  let images = [UIImage(named: "dnf1"),UIImage(named: "dnf2"),UIImage(named: "dnf3"),UIImage(named: "dnf4"),UIImage(named:   "dnf5"),UIImage(named: "dnf6"),UIImage(named: "dnf7")]   
  //可以传入url数组用来显示网络图片    
  DVImageBrowserVC.show(target: self, transitionType: DVImageVCTransitionType.push, images: images, index: 0, deleteBlock: nil)    
  
  ## 三. Requirements 要求
   iOS8及以上系统可使用. ARC环境. 
   
   ## 四. More 更多 
   如果你发现了bug,请与我联系，邮箱:654070281@qq.com
