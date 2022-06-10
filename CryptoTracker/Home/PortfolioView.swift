import SwiftUI

struct PortfolioView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var selectedCoin: Coin? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $homeViewModel.searchText)

                    coinLogoList

                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
              .navigationTitle("Edit Portfolio")
              .toolbar(content: {
                           ToolbarItem(placement: .navigationBarLeading) {
                               Button(action: {
                                          print("Dismissing...")
                                          presentationMode.wrappedValue.dismiss()
                                      }, label: {
                                             Image(systemName: "xmark")
                                               .font(.headline)
                                         })
                           }
                           // .toolbar(content: {
                           //              ToolbarItem(placement: .navigationBarLeading) {
                           //                  XMarkButton()
                           //              }
                           //          })
                           ToolbarItem(placement: .navigationBarTrailing) {
                               trailingNavBarButtons
                           }
                       })
              .onChange(of: homeViewModel.searchText,
                        perform: { value in
                            if value == "" {
                                removeSelectedCoin()
                            }
                        })
        }
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false,
                   content: {
                       LazyHStack(spacing: 10) {
                           ForEach(homeViewModel.searchText.isEmpty ? homeViewModel.portfolioCoins : homeViewModel.allCoins) { coin in
                               CoinLogoView(coin: coin)
                                 .frame(width: 75)
                                 .onTapGesture {
                                     withAnimation(.easeIn) {
                                         selectedCoin = coin
                                     }
                                 }
                                 .background(
                                   RoundedRectangle(cornerRadius: 10)
                                     .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                                 )
                           }
                       }
                   })
          .frame(height: 120)
          .padding(.leading)
    }

    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin

        if let portfolioCoin = homeViewModel.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }

    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }

            Divider()

            HStack {
                Text("Amount holding")
                TextField("ex 1.4", text: $quantityText)
                  .multilineTextAlignment(.trailing)
                  .keyboardType(.decimalPad)
            }

            Divider()

            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
          .animation(.none)
          .padding()
          .font(.headline)
    }

    private var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
              .opacity(showCheckmark ? 1.0 : 0.0)

            Button(action: {
                       saveButtonPressed()
                       // presentationMode.wrappedValue.dismiss()
                   }, label: {
                          Text("Save")
                      })
              .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0)
        }
          .font(.headline)
    }

    private func saveButtonPressed() {
        print("Save...")
        guard
          let coin = selectedCoin,
          let amount = Double(quantityText)
        else { return }

        homeViewModel.updatePortfolio(coin: coin, amount: amount)

        // Save to portfolio
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }

        // hide keyboard
        UIApplication.shared.endEditing()

        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }

    private func removeSelectedCoin() {
        selectedCoin = nil
        homeViewModel.searchText = ""

        // Dismiss the keyboard
        UIApplication.shared.endEditing()

        // Hide checkmark after a couple seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("Setting showCheckmark to false")
            showCheckmark = false
        }
    }

    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
          .environmentObject(dev.homeViewModel)
    }
}
