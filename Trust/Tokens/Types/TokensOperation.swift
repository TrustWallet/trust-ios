// Copyright SIX DAY LLC. All rights reserved.

import TrustKeystore

class TokensOperation: TrustOperation {
    private let store: TokensDataStore
    private var network: TokensNetworkProtocol
    private let address: Address
    var tokens: [TokenObject] = [TokenObject]()

    init(
        store: TokensDataStore,
        network: TokensNetworkProtocol,
        address: Address
    ) {
        self.store = store
        self.network = network
        self.address = address
    }

    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        fetchTokensList()
    }

    private func fetchTokensList() {
        executing(true)
        network.tokensList(for: address) { result in
            guard let tokensList = result else {
                self.executing(false)
                self.finish(true)
                return
            }
            self.store.updateInfo(for: tokensList)
            self.executing(false)
            self.finish(true)
        }
    }
}
