import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false

    private let coin: Coin
    private let coinImageAPI: CoinImageAPI

    private var cancellables = Set<AnyCancellable>()

    init(coin: Coin) {
        self.coin = coin
        self.coinImageAPI = CoinImageAPI(coin: coin)
        addSubscribers()
        self.isLoading = true
    }

    private func addSubscribers() {
        coinImageAPI.$image
          .sink { [weak self] (_) in
                  self?.isLoading = false
          } receiveValue: { [weak self] (returnedImage) in
              self?.image = returnedImage
          }
          .store(in: &cancellables)
    }
}
