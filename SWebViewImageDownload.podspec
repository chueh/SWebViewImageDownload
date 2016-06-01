Pod::Spec.new do |s|

  s.name         = "SWebViewImageDownload"
  s.version      = "1.0.2"
  s.summary      = "取得網頁或HTML Body內的imageURL"
  s.homepage     = "https://github.com/chueh/SWebViewImageDownload"
  s.license      = "MIT"
  s.author       = { "alexchueh" => "a855140@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/chueh/SWebViewImageDownload", :tag => "1.0.2" }
  s.source_files  = "SWebViewImageDownload", "*.{h,m}"
  s.requires_arc = true
end
