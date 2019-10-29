#
#  Be sure to run `pod spec lint AdvertisingSlider.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "AdvertisingSlider"
  s.version      = "0.9.2"
  s.summary      = "It's simple way to show some images with text in yours iOS appication"
  s.description  = <<-DESC 
						Control to show some pictures with text. Simple to use. Just add UIView in your xib or storyboard and change class name on "AdvertisingSlider". More information in GitHub account.
                   DESC
  s.homepage     = "https://github.com/seroshtanov/AdvertisingSlider"
  s.license      = "MIT licence"
  s.author             = { "Vitaly Seroshtanov" => "v.s.seroshtanov@gmail.com" }


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "10.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/seroshtanov/AdvertisingSlider.git", :tag => "#{s.version}"}

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "AdvertisingSlider/AdvertisingSlider/AdvertisingSlider/*.{swift}"
  s.swift_version = "5.0"
  
  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.resources = "AdvertisingSlider/AdvertisingSlider/AdvertisingSlider/*.{xcassets}"
	


end
