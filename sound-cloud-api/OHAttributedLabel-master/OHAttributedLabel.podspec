Pod::Spec.new do |s|
  s.name     = 'OHAttributedLabel'
  s.version  = '0.0.1.nxtbgthng.1'
  s.license  = 'MIT'
  s.summary  = 'UILabel that supports NSAttributedString. (nxtbgthng experimental pod)'
  s.homepage = 'https://github.com/AliSoftware/OHAttributedLabel'
  s.author   = { 'AliSoftware' => 'olivier.halligon+ae@gmail.com',
                 'Ullrich Schäfer' => 'ullrich.schaefer@gmail.com' }

  s.source   = { :git => 'https://github.com/nxtbgthng/OHAttributedLabel.git', :commit => '11c9b1c45d9938718af7e131079988b45b434bab' }

  s.description = 'Don\'t use this Pod. Rather use one of the official OHAttributedLabel Pods'

  s.platform = :ios

  s.source_files = 'OHAttributedLabel/*.{h,m}'


  s.framework = 'CoreText'
end
