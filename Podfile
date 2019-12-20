platform :ios, '13.0'

inhibit_all_warnings!
use_frameworks!

target 'RateMyTeam' do
    #pod 'TezosSwift/Combine', :path => '/Users/marekfort/Development/ackee/TezosSwift'
    pod 'TezosSwift/Combine', :git => 'https://github.com/AckeeCZ/TezosSwift', :branch => 'fixes'
    pod 'SwiftGen', '~> 6.0'

	target 'RateMyTeamTests' do
		inherit! :complete
	end

	target 'RateMyTeamUITests' do
		inherit! :complete
	end
end
