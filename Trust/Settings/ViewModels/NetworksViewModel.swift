// Copyright SIX DAY LLC. All rights reserved.

import Foundation

struct NetworksViewModel {

    let networksStore: RPCStore

    init(
        networksStore: RPCStore
    ) {
        self.networksStore = networksStore
    }

    var hasCustomNetworks: Bool {
        return !networksStore.endpoints.isEmpty
    }

    var networkTitle: String {
        return NSLocalizedString("settings.network.button.title", value: "Network", comment: "")
    }

    func add(network: CustomRPC) {
        networksStore.add(endpoints: [network])
    }

    func delete(network: CustomRPC) {
        networksStore.delete(endpoints: [network])
    }

    var servers: [RPCServer] {
        return [
            RPCServer.main,
            RPCServer.classic,
            RPCServer.poa,
            //RPCServer.callisto,
            RPCServer.kovan,
            RPCServer.ropsten,
            RPCServer.rinkeby,
            RPCServer.sokol,
        ]
    }

    var customServers: [CustomRPC] {
        return Array(networksStore.endpoints)
    }
}
