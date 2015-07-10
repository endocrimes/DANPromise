Pod::Spec.new do |s|
  s.name                = "DANPromise"
  s.version             = "1.0.0"
  s.summary             = "A threadsafe, lightweight implementation of Promises in Objective-C"
  s.description         = "DANPromise is a lightweight implementation of Promises in Objective-C to make it easy to clean up asyncronous code."
  s.homepage            = "https://github.com/endocrimes/DANPromise"
  s.license             = { :type => "MIT", :file => "LICENSE" }
  s.author              = { "Danielle Lancashire" => "Dan@Tomlinson.io" }
  s.social_media_url    = "http://twitter.com/endocrimes"
  s.platform            = :ios, "7.0"
  s.source              = { :git => "https://github.com/endocrimes/DANPromise.git", :tag => s.version.to_s }
  s.source_files        = "Classes", "DANPromise/**/*.{h,m}"
  s.public_header_files = "DANPromise/{DANPromise,DANDeferredValue}.h"
  s.requires_arc        = true
end
