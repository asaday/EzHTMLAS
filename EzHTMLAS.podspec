
Pod::Spec.new do |s|

s.name = "EzHTMLAS"
s.version = "0.1.3"
s.summary = "HTML to AttributedString"

s.homepage = "http://nagisaworks.com"
s.license = { :type => "MIT" }
s.author = { "asaday" => "" }

s.ios.deployment_target = '8.0'
s.tvos.deployment_target = '9.0'

s.source = { :git=> "https://github.com/asaday/EzHTMLAS.git", :tag => s.version }
s.source_files  = "sources/**/*.{swift,h,m}"
s.libraries = 'xml2'

s.module_map = 'resources/module.modulemap'
s.private_header_files = 'sources/libxml2_re.h'

end