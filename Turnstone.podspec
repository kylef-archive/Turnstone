Pod::Spec.new do |spec|
  spec.name = 'Turnstone'
  spec.version = '0.1.0'
  spec.summary = 'Lightweight request routing for Nest using URI Template.'
  spec.homepage = 'https://github.com/kylef/Turnstone'
  spec.license = { :type => 'BSD', :file => 'LICENSE' }
  spec.author = { 'Kyle Fuller' => 'kyle@fuller.li' }
  spec.social_media_url = 'http://twitter.com/kylefuller'
  spec.source = { :git => 'https://github.com/kylef/Turnstone.git', :tag => "#{spec.version}" }
  spec.source_files = 'Turnstone/*.swift'
  spec.requires_arc = true
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'

  spec.dependency 'Nest', '~> 0.1.0'
  spec.dependency 'Inquiline', '~> 0.1.0'
  spec.dependency 'URITemplate', '~> 1.1'
end

