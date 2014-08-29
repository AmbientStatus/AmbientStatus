Pod::Spec.new do |spec|
      spec.name         = 'AmbientStatus'
      spec.version      = '0.1.0'
      spec.license      = { :type => 'MIT', :file => 'LICENSE' }
      spec.summary      = 'Seamlesssly update your app based on the ambiance of your users.'
      spec.homepage     = 'https://github.com/AmbientStatus/AmbientStatus'
      spec.author       = { 'Rudd Fawcett' => 'rudd.fawcett@gmail.com' }
      spec.source       = { :git => 'https://github.com/AmbientStatus/AmbientStatus.git', :tag => spec.version.to_s }
      spec.source_files = 'Pod/Classes/AmbientStatus.h'
      spec.platform     = :ios, '7.0'
      spec.requires_arc = true

      spec.subspec 'Core' do |ss|
        ss.source_files = 'Pod/Classes/AmbientStatus.h'
      end

      spec.subspec 'ASTransitMonitor' do |ss|
        ss.dependency 'AmbientStatus/Core'
        ss.dependency 'AmbientStatus/ASLocationMonitor'
        ss.dependency 'ASTransitMonitor'
      end

      spec.subspec 'ASLocationMonitor' do |ss|
        ss.dependency 'AmbientStatus/Core'
        ss.dependency 'ASLocationMonitor'
      end

      spec.subspec 'ASBatteryMonitor' do |ss|
        ss.dependency 'AmbientStatus/Core'
        ss.dependency 'ASBatteryMonitor'
      end
end
