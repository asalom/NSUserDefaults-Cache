Pod::Spec.new do |s|
  s.name             = "NSUserDefaults+Cache"
  s.version          = "0.1.1"
  s.summary          = "NSUserDefaults category one liner that also includes a cache so we only need to access disk once per item."
  s.homepage         = "https://github.com/asalom/NSUserDefaults-Cache"
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Alex Salom" => "hola@alexsalom.es" }
  s.source           = {
    :git => 'https://github.com/asalom/NSUserDefaults-Cache.git',
    :branch => 'master',
    :tag => s.version.to_s
  }
  s.platform     = :ios, '5.0'
  s.requires_arc = true
  s.source_files = 'NSUserDefaults+Cache/*.{h,m}'
  s.public_header_files = 'NSUserDefaults+Cache/*.h'
end
