import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var showPortfolio: Bool = false // animate right
    @State private var showPortfolioView: Bool = false // new sheet

    var body: some View {
        ZStack {
            Color.theme.background
              .ignoresSafeArea()
              .sheet(isPresented: $showPortfolioView,
                     content: {
                         PortfolioView()
                           .environmentObject(homeViewModel)
                     })

            VStack {
                homeHeader

                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $homeViewModel.searchText)

                columnTitles

                if !showPortfolio {
                    allCoinsList
                      .transition(.move(edge: .leading))
                }

                if showPortfolio {
                    portfolioCoinsList
                      .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }
        }
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
              .animation(.none)
              .onTapGesture {
                  if showPortfolio {
                      showPortfolioView.toggle()
                  }
              }
              .background(CircleButtonAnimationView(animate: $showPortfolio))

            Spacer()

            Text(showPortfolio ? "Portfolio" : "Live Prices")
              .font(.headline)
              .fontWeight(.heavy)
              .foregroundColor(Color.theme.accent)
              .animation(.none)

            Spacer()

            CircleButtonView(iconName: "chevron.right")
              .rotationEffect(Angle(degrees: showPortfolio ? 90: 0))
              .onTapGesture {
                  withAnimation(.spring()) {
                      showPortfolio.toggle()
                  }
              }
        }
          .padding(.horizontal)
    }

    private var allCoinsList: some View {
        List {
            ForEach(homeViewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                  .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
          .listStyle(PlainListStyle())
    }

    private var portfolioCoinsList: some View {
        List {
            ForEach(homeViewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                  .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
          .listStyle(PlainListStyle())
    }

    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Spacer()
            Text("Price")
              .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)

            Button(action: {
                       withAnimation(.linear(duration: 2.0)) {
                           homeViewModel.reloadData()
                       }
                   }, label: {
                          Image(systemName: "goforward")
                      })
              .rotationEffect(Angle(degrees: homeViewModel.isLoading ? 360 : 0), anchor: .center)
        }
          .font(.caption)
          .foregroundColor(Color.theme.secondaryText)
          .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
              .navigationBarHidden(true)
        }
          .environmentObject(dev.homeViewModel)
    }
}
