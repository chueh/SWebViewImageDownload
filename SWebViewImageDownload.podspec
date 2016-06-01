
Pod::Spec.new do |s|

  s.name         = "SWebViewImageDownload"
  s.version      = "0.0.2"
  s.summary      = "取得網頁或HTML Body內的imageURL"
  s.homepage     = "https://github.com/chueh/SWebViewImageDownload"
  s.license      = "MIT"
  s.author             = { "alexchueh" => "shadow@pixnet.tw" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/chueh/SWebViewImageDownload", :tag => "1.0.1" }
  s.source_files  = "SWebViewImageDownload", "*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
end
