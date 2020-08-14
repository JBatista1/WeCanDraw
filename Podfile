platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!
workspace 'WeCanDraw'

def sharedPods
  pod 'SwiftLint'
end

def diPods
  pod 'Swinject', '~> 2.7.1'
  pod 'SwinjectAutoregistration', '~> 2.7.0'
end

target 'WeCanDraw' do
  sharedPods
  diPods

  target 'WeCanDrawTests' do
    inherit! :search_paths
  end

end
