import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var statistics: [Statistic] = []

    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""

    @Published var sortOption: SortOption = .holdings

    private let coinAPI = CoinAPI()
    private let marketDataAPI = MarketDataAPI()
    private let portfolioDataSerivce = PortfolioDataService()

    private var cancellables = Set<AnyCancellable>()

    enum SortOption {
        case rank
        case rankReversed
        case holdings
        case holdingsReversed
        case price
        case priceReversed
    }

    init() {
        addSubscribers()
    }

    func addSubscribers() {
        $searchText
          .combineLatest(coinAPI.$allCoins, $sortOption)
          .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
          .map(filterAndSortCoins)
          .sink { [weak self] (returnedCoins) in
              self?.allCoins = returnedCoins
          }
          .store(in: &cancellables)

        // update portfolio coins
        $allCoins
          .combineLatest(portfolioDataSerivce.$savedEntities)
          .map(mapCoinsToPortfolioCoins)
          .sink { [weak self] (returnedCoins) in
              self?.portfolioCoins = returnedCoins
          }
          .store(in: &cancellables)

        // update marketData
        marketDataAPI.$marketData
          .combineLatest($portfolioCoins)
          .map(mapGlobalMarketData)
          .sink { [weak self] (returnedStats) in
              self?.statistics = returnedStats
              self?.isLoading = false
          }
          .store(in: &cancellables)
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataSerivce.updatePortfolio(coin: coin, amount: amount)
    }

    func reloadData() {
        isLoading = true
        coinAPI.getCoins()
        marketDataAPI.getData()
        HapticManager.notification(type: .success)
    }

    func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
        var filteredCoins = filterCoins(text: text, coins: coins)

        // sort

        return filterCoins
    }

    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
              coin.symbol.lowercased().contains(lowercasedText) ||
              coin.id.lowercased().contains(lowercasedText)
        }
    }

    private func sortCoins(sort: SortOption, coins: [Coin]) -> [Coin] {
        switch sort {
        case .rank:
            return coins.sortedBy { (coin1, coin2) -> Bool in
            }
        case rankReversed
        case holdings
        case holdingsReversed
        case price
        case priceReversed
    }

    private func mapCoinsToPortfolioCoins(allCoins: [Coin], portfolioEntities: [Portfolio]) -> [Coin] {
        allCoins
          .compactMap { (coin) -> Coin? in
              guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                  return nil
              }
              return coin.updateCurrentHoldings(amount: entity.amount)
          }
    }

    private func mapGlobalMarketData(marketData: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        guard let data = marketData else {
            return stats
        }

        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)

        let portfolioValue = portfolioCoins
          .map({ $0.currentHoldingsValue })
          .reduce(0, +)

        let previousValue =
          portfolioCoins
          .map { (coin) -> Double in
              let currentValue = coin.currentHoldingsValue
              let percentChange = (coin.priceChangePercentage24H ?? 0.0) / 100
              let previousValue = currentValue / (1 + percentChange)
              return previousValue
          }
          .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100

        let portfolio = Statistic(title: "Portfolio Value",
                                  value: portfolioValue.asCurrencyWith2Decimals(),
                                  percentageChange: percentageChange)
        stats.append(contentsOf: [ marketCap, volume, btcDominance, portfolio ])
        return stats
    }
}
