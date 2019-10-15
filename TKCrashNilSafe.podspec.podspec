#
#  Be sure to run `pod spec lint TKCrashNilSafe.podspec.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

name = "TKCrashNilSafe"
file_source       = "*.{h,m}"
file_header       = "*.h"
public_source     = "TKCrashNilSafe/NSObject/NSObject+CrashNilSafe.{h,m}"
public_header     = "TKCrashNilSafe/NSObject/NSObject+CrashNilSafe.h"
public_base       = "TKCrashNilSafe/NSObject"

Pod::Spec.new do |spec|

  spec.name         = "TKCrashNilSafe"   #框架名称
  spec.version      = "1.0"         #版本
  spec.summary      = "防止Crash奔溃问题"          #简短的描述
  spec.description  = <<-DESC
  TKCrashNilSafe
                   DESC
  spec.homepage     = "https://github.com/RANSAA/TKPermissionKit"   #github项目首页
  spec.license      = "MIT"     #开源协议方式
  spec.author             = { "sayaDev" => "1352892108@qq.com" }    #作者
  spec.source       = { :git => "https://github.com/RANSAA/TKPermissionKit.git", :tag => "v#{spec.version}" } #对应github资源与版本
  spec.requires_arc = true    #支持arc

  # spec.platform     = :ios
  spec.platform     = :ios, "8.0"         #支持版本

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  # spec.source_files     = public_source,"#{name}/*.*","#{name}/**/*.*"  #源文件路径相关
  # spec.public_header_files = public_header,"#{name}/*.h","#{name}/**/*.h"

  spec.source_files         = "#{name}/TKCrashNilSafe.h"
  spec.public_header_files  = "#{name}/TKCrashNilSafe.h"

  

    #分支 
  spec.subspec 'NSObject' do |ss|
    ss.source_files         = public_source
    ss.public_header_files  = public_header
    ss.ios.frameworks       = "Foundation"
  end

  spec.subspec 'NSArray' do |ss|
    ss.source_files         = "#{name}/NSArray/#{file_source}"
    ss.public_header_files  = "#{name}/NSArray/#{file_header}"
    ss.dependency "#{public_base}"    #依赖
  end

  spec.subspec 'NSAttributedString' do |ss|
    ss.source_files         = "#{name}/NSAttributedString/#{file_source}"
    ss.public_header_files  = "#{name}/NSAttributedString/#{file_header}"
    ss.dependency "#{public_base}"    #依赖
  end

  spec.subspec 'NSCache' do |ss|
    ss.source_files         = "#{name}/NSCache/#{file_source}"
    ss.public_header_files  = "#{name}/NSCache/#{file_header}"
    ss.dependency "#{public_base}"    #依赖
  end

  spec.subspec 'NSData' do |ss|
    ss.source_files         = "#{name}/NSData/#{file_source}"
    ss.public_header_files  = "#{name}/NSData/#{file_header}"
    ss.dependency "#{public_base}"    #依赖
  end

  spec.subspec 'NSDictionary' do |ss|
    ss.source_files         = "#{name}/NSDictionary/#{file_source}"
    ss.public_header_files  = "#{name}/NSDictionary/#{file_header}"
    ss.dependency "#{public_base}"    #依赖
  end

  spec.subspec 'NSSet' do |ss|
    ss.source_files         = "#{name}/NSSet/#{file_source}"
    ss.public_header_files  = "#{name}/NSSet/#{file_header}"
    ss.dependency "#{public_base}"    #依赖
  end

  spec.subspec 'NSString' do |ss|
    ss.source_files         = "#{name}/NSString/#{file_source}"
    ss.public_header_files  = "#{name}/NSString/#{file_header}"
    ss.dependency "#{public_base}"    #依赖
  end






  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
