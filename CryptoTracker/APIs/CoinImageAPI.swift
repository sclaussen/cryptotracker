import Foundation
import SwiftUI
import Combine

class CoinImageAPI {
    @Published var image: UIImage? = nil

    private var imageSubscription: AnyCancellable?
    private var coin: Coin
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String

    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }

    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            print("Image in cache")
            image = savedImage
        } else {
            print("Downloading image")
            downloadCoinImage()
        }
    }

    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }

        imageSubscription = Curl.get(url: url)
          .tryMap({ (data) -> UIImage? in
                      return UIImage(data: data)
                  })
          .sink(receiveCompletion: Curl.handleCompletion,
                receiveValue: { [weak self] (returnedImage) in
                    guard let self = self,
                          let downloadImage = returnedImage else { return }
                    self.image = returnedImage
                    self.imageSubscription?.cancel()
                    self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.folderName)
                })
    }
}
