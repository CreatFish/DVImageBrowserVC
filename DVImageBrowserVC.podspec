Pod::Spec.new do |s|

  s.name         = "DVImageBrowserVC"  #存储库名称
  s.version      = "1.0.2"          #版本号
  s.summary      = "DVImageBrowserVC" #简介
  s.description  = "一个自用的照片选择vc"   #描述
  s.homepage     = "https://github.com/CreatFish/DVImageBrowserVC" #项目主页，不是git地址
  s.author       = { "GreatFish" => "654070281@qq.com" } #作者
  s.platform     = :ios, "8.0"  #支持的平台和版本号
  s.source       = { :git => "https://github.com/CreatFish/DVImageBrowserVC.git", :tag => "1.0.1" } #存储库的git地址，以及tag值
  s.source_files  = "DVImageBrowserVCDemo/DVImageBrowserVC/*"
  s.resources  = "DVImageBrowserVCDemo/DVImageBrowserVC/Resources/*.png"
  s.requires_arc = true #是否支持ARC
  s.swift_version = "4.2"
  s.dependency 'SDWebImage', '~> 4.0'
  s.dependency 'DVActionSheetVC', '~> 1.0.0'

end
