Pod::Spec.new do |s|
 s.name = 'DarkSkySwift'
 s.version = '0.0.1'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'DarkSky API Swift Framework'
 s.homepage = 'https://www.applicodo.com'
 s.social_media_url = 'https://twitter.com/cyupa89'
 s.authors = { "Ciprian Redinciuc" => "ciprian@applicodo.com" }
 s.source = { :git => "https://github.com/cyupa/DarkSkySwift.git", :tag => "v"+s.version.to_s }
 s.platforms     = { :ios => "8.0", :osx => "10.10", :tvos => "9.0", :watchos => "2.0" }
 s.requires_arc = true

 s.default_subspec = "Core"
 s.subspec "Core" do |ss|
     ss.source_files  = "Sources/*.swift"
     ss.framework  = "Foundation"
 end

end
