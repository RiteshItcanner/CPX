//
//  AnalyticsEventProtocolModel.swift
//  Moon
//
//  Created by PYTHON on 11/09/23.
//

protocol EventProtocol {
    var names: [TrackingSDK: String] { get set }
    var params: [TrackingSDK: [String: Any]] { get set }
    var isDynamicEvent: Bool { get set }
}

@propertyWrapper
struct Event: EventProtocol {
    var names: [TrackingSDK: String]
    var params: [TrackingSDK: [String: Any]]
    var isDynamicEvent: Bool = false

    var wrappedValue: Event {
        return Event(names: names,
                     params: params,
                     isDynamicEvent: isDynamicEvent)
    }
}

// Helper init method to send same Event and params in given list of SDK
extension Event {
    init(name: String,
         params: [String: Any] = [:],
         trackingSDKs: [TrackingSDK] = [.firebase],
         isDynamicEvent: Bool = false) {
        // Send to all
        var _names: [TrackingSDK: String] = [:]
        var _params: [TrackingSDK: [String: Any]] = [:]

        for sdk in trackingSDKs {
            _names[sdk] = name
            _params[sdk] = params
        }
        self.init(names: _names,
                  params: _params,
                  isDynamicEvent: isDynamicEvent)
    }

    init(names: [TrackingSDK: String],
         params: [String: Any]? = nil,
         isDynamicEvent: Bool = false) {
        var _params: [TrackingSDK: [String: Any]] = [:]
        for (sdk, _) in names {
            _params[sdk] = params ?? [:]
        }
        self.init(names: names,
                  params: _params,
                  isDynamicEvent: isDynamicEvent)
    }
}
