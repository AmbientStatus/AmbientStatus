Pod::Spec.new do |spec|
      spec.name         = 'AmbientStatus'
      spec.version      = '0.1.0'
      spec.license      = { :type => 'MIT', :file => 'LICENSE' }
      spec.summary      = 'Seamlesssly update your app based on the ambiance of your users.'
      spec.homepage     = 'https://github.com/AmbientStatus/AmbientStatus'
      spec.author       = { 'Rudd Fawcett' => 'rudd.fawcett@gmail.com' }
      spec.source       = { :git => 'https://github.com/AmbientStatus/AmbientStatus.git', :tag => spec.version.to_s }
      spec.source_files = 'Pod/Classes/'
      spec.platform     = :ios, '7.0'
      spec.requires_arc = true

      transit           = { :pod_name => 'ASTransitMonitor' }
      location          = { :pod_name => 'ASLocationMonitor' }
      battery           = { :pod_name => 'ASBatteryMonitor' }

      $all_monitors     = [transit, location, battery]

      # make specs for each monitor
      $all_monitors.each do |monitor_spec|
            spec.subspec monitor_spec[:pod_name] do |ss|
                 # If there's a podspec dependency include it
                 Array(monitor_spec[:pod_name]).each do |dep|
                     ss.dependency dep
                 end

                 monitor_name = monitor_spec[:pod_name].sub! 'AS', ''

                 # Each subspec adds a compiler flag saying that the spec was included
                 # This should be used to manage a header for every ASClass, but for
                 # some reason, that's not working, so open an issue if you can help!
                 ss.prefix_header_contents = '#define AS_' + monitor_name.upcase + '_EXISTS 1'
             end
        end
end
