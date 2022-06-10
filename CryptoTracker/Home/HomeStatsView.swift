import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Binding var showPortfolio: Bool

    var body: some View {
        HStack {
            ForEach(homeViewModel.statistics) { stat in
                StatisticView(stat: stat)
                  .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
          .frame(width: UIScreen.main.bounds.width,
                 alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeStatsView(showPortfolio: .constant(false))
              .environmentObject(dev.homeViewModel)
              .previewLayout(.sizeThatFits)
            HomeStatsView(showPortfolio: .constant(false))
              .environmentObject(dev.homeViewModel)
              .previewLayout(.sizeThatFits)
              .preferredColorScheme(.dark)
            HomeStatsView(showPortfolio: .constant(true))
              .environmentObject(dev.homeViewModel)
              .previewLayout(.sizeThatFits)
            HomeStatsView(showPortfolio: .constant(true))
              .environmentObject(dev.homeViewModel)
              .previewLayout(.sizeThatFits)
              .preferredColorScheme(.dark)
        }
    }
}
