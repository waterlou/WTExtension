Pod::Spec.new do |s|

  s.name          = 'WTExtension'
  s.version       = '1.2.1'
  s.summary       = 'Some useful categories used in other public libraries.'
  s.homepage      = 'https://github.com/waterlou/WTExtension'
  s.license       = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author        = { 'waterlou' => 'https://github.com/waterlou' }

  s.platform      = :ios, '5.0'
  s.requires_arc  = true
  s.source        = { :git => 'https://github.com/waterlou/WTExtension.git', :tag => "#{s.version}" }

  s.subspec 'UIImage+WTExtension' do |l|
  	l.source_files  = 'UIImage+WTExtension/*.{h,m}'
  	l.frameworks    = 'UIKit', 'QuartzCore'
  end

  s.subspec 'UIView+WTExtension' do |l|
  	l.source_files  = 'UIView+WTExtension/*.{h,m}'
  	l.frameworks    = 'UIKit'
  end

  s.subspec 'UIView+WTLayer' do |l|
  	l.source_files  = 'UIView+WTLayer/*.{h,m}'
  	l.frameworks    = 'UIKit', 'QuartzCore'
  end

  s.subspec 'UIDevice+WTExtension' do |l|
  	l.source_files  = 'UIDevice+WTExtension/*.{h,m}'
  	l.frameworks    = 'UIKit'
  end

  s.subspec 'UIWebView+WTExtension' do |l|
  	l.source_files  = 'UIWebView+WTExtension/*.{h,m}'
  	l.frameworks    = 'UIKit'
  end

  s.subspec 'UIImage+WTFaceDetection' do |l|
  	l.source_files  = 'UIImage+WTFaceDetection/*.{h,m}'
  	l.frameworks    = 'UIKit', 'CoreImage'
  end

  # Filters
  s.subspec 'UIImage+WTFilterFastBlur' do |l|
  	l.source_files  = 'UIImage+WTFilter/UIImage+WTFilterFastBlur.{h,m}'
  	l.frameworks    = 'UIKit', 'Accelerate'
  end
  s.subspec 'UIImage+WTFilterBlur' do |l|
  	l.source_files  = 'UIImage+WTFilter/UIImage+WTFilterBlur.{h,m}'
  	l.frameworks    = 'UIKit', 'CoreImage'
  end
  # All Filters
  s.subspec 'UIImage+WTFilter' do |l|
  	l.source_files  = 'UIImage+WTFilter/UIImage+WTFilter.h'
  	l.dependency 'WTExtension/UIImage+WTFilterFastBlur'
  	l.dependency 'WTExtension/UIImage+WTFilterBlur'
  end

end
