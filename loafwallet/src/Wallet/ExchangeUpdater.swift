import Foundation

class ExchangeUpdater: Subscriber {
    // MARK: - Public

    init(store: Store, walletManager: WalletManager) {
        self.store = store
        self.walletManager = walletManager
        store.subscribe(self,
                        selector: { $0.defaultCurrencyCode != $1.defaultCurrencyCode },
                        callback: { state in
                            guard let currentRate = state.rates.first(where: { $0.code == state.defaultCurrencyCode }) else { return }
                            self.store.perform(action: ExchangeRates.setRate(currentRate))
        })
    }

    func refresh(completion: @escaping () -> Void) {
        walletManager.apiClient?.exchangeRates { rates, _ in
            guard let currentRate = rates.first(where: { $0.code == self.store.state.defaultCurrencyCode }) else { completion(); return }
            self.store.perform(action: ExchangeRates.setRates(currentRate: currentRate, rates: rates))
            completion()
        }
    }

    // MARK: - Private

    let store: Store
    let walletManager: WalletManager
}
