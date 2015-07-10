Pod::Spec.new do |s|
  s.name                = "DANPromise"
  s.version             = "1.0.0"
  s.summary             = "A threadsafe, lightweight implementation of Promises in Objective-C"
  s.description         =  <<-DESC
                           DANPromise is a lightweight implementation of Promises in Objective-C to make it
									         easy to cleanup asyncronous code.
                           DESC
  s.homepage            = "https://github.com/DanielTomlinson/DANPromise"
  s.license             = { :type => "MIT", :file => "LICENSE" }
  s.author              = { "Daniel Tomlinson" => "Dan@Tomlinson.io" }
  s.social_media_url    = "http://twitter.com/DanToml"
  s.platform            = :ios, "7.0"
	s.source              = { :git => "https://github.com/DanielTomlinson/DANPromise.git", :tag => s.version }
  s.source_files        = "Classes", "DANPromise/**/*.{h,m}"
	s.public_header_files = "DANPromise/{DANPromise,DANDeferredValue}.h"
  s.requires_arc        = true
end
