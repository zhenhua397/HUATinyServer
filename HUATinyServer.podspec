Pod::Spec.new do |spec|
  spec.name = 'HUATinyServer'
  spec.version = '1.0.0'
  spec.license =  { :type => 'BSD', :file => "LICENSE" }
  spec.homepage = 'https://github.com/zhenhua397/HUATinyServer'
  spec.documentation_url = 'https://github.com/zhenhua397/HUATinyServer'

  spec.summary = ''
  spec.description = ''

  spec.authors = 'zhenhua397'
  spec.source = {
    :git => 'https://github.com/zhenhua397/HUATinyServer.git',
    :tag => '1.0.0',
  }

  spec.source_files = 'HUATinyServer/**/*.{m,h}'
end
