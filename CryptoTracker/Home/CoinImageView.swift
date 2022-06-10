import SwiftUI

struct CoinImageView: View {
    @StateObject var coinImageViewModel: CoinImageViewModel

    init(coin: Coin) {
        _coinImageViewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }

    var body: some View {
        ZStack {
            if let image = coinImageViewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if coinImageViewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
