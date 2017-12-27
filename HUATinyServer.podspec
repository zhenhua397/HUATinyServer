Pod::Spec.new do |spec|
  spec.name = 'HUATinyServer'
  spec.version = '1.0.0'
  spec.license =  { :type => 'BSD', :file => "LICENSE" }
  spec.homepage = 'https://github.com/zhenhua397/HUATinyServer'
  spec.documentation_url = 'https://github.com/zhenhua397/HUATinyServer'

  spec.summary = 'a tiny http server on device to edit json file'
  spec.description = 'for test'

  spec.authors = 'zhenhua397'
  spec.source = {
    :git => 'https://github.com/zhenhua397/HUATinyServer.git',
    :tag => '1.0.0',
  }

  spec.ios.deployment_target = '8.0'
  spec.requires_arc = true

  spec.source_files = 'HUATinyServer/HUATinyServer.{h,m}'

  spec.subspec 'GCDWebServer' do |cs|
  cs.source_files = 'HUATinyServer/GCDWebServer/**/*.{h,m}'
  end
end
