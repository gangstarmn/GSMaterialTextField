 Pod::Spec.new do |s|
  s.name         = "GSMaterialTextField"
  s.version      = "0.0.1"
  s.summary      = "GSTextField is a error view with UITextField"
  s.description  = <<-DESC
                    Алдаа харуулдаг, Мөн алдааны мэссэж харуулдаг UITextfield.
                   DESC
  s.homepage     = "https://github.com/gangstarmn/GSMaterialTextField"
  s.license      = "MIT"
  s.author             = { "Gantulga" => "gangstarmn@gmail.com" }
  s.platform = :ios, '8.0'
  s.source = { :git => 'https://github.com/gangstarmn/GSMaterialTextField.git', :tag => "#{s.version}" }
  
  s.source_files = "GSMaterialTextField/**/*.{h,m}"
  
  s.resources = "GSMaterialTextField/**/*.{xib,xcassets,bundle}"
  
  s.framework = 'UIKit'
  s.requires_arc = true
  s.dependency 'InputValidators'
  s.dependency 'SCViewShaker'
  s.dependency 'HexColors'
  s.dependency 'GSLocalization'

  end