
Pod::Spec.new do |s|

s.name         = "EzHTMLAS"
s.version      = "0.0.5"
s.summary      = "HTML to AttributedString"

s.homepage     = "http://nagisaworks.com"
s.license     = { :type => "MIT" }
s.author       = { "asaday" => "" }

s.platform     = :ios, "8.0"
s.source       = { :git=> "https://github.com/asaday/EzHTMLAS.git", :tag => s.version }
s.source_files  = "sources/**/*.{swift,h,m}"
s.libraries = 'xml2'
s.requires_arc = true

s.module_map = 'resources/module.modulemap'
s.private_header_files = 'sources/libxml2_re.h'


end