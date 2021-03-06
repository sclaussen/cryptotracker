import Foundation

struct GlobalData: Codable {
    let data: MarketData?
}

struct MarketData: Codable {
    let totalMarketCap: [String: Double]
    let totalVolume: [String: Double]
    let marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }

    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }

    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }

    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
}

/*
https://app.quicktype.io/
https://api.coingecko.com/api/v3/global
{
  "data": {
    "active_cryptocurrencies": 13596,
    "upcoming_icos": 0,
    "ongoing_icos": 49,
    "ended_icos": 3376,
    "markets": 788,
    "total_market_cap": {
      "btc": 48491395.60368718,
      "eth": 653089482.9576175,
      "ltc": 18546454959.05725,
      "bch": 6264377938.980254,
      "bnb": 4846947248.850478,
      "eos": 838638765193.3239,
      "xrp": 2683320308230.1597,
      "xlm": 9907303623860.26,
      "link": 134057249881.9002,
      "dot": 103271391690.03232,
      "yfi": 99242089.48986092,
      "usd": 2118485110188.3687,
      "aed": 7781407658232.91,
      "ars": 237208440798603.16,
      "aud": 2831891326499.6343,
      "bdt": 182655423939487.12,
      "bhd": 798770573826.3065,
      "bmd": 2118485110188.3687,
      "brl": 10070007122769.408,
      "cad": 2666204606031.801,
      "chf": 1979724335471.0317,
      "clp": 1703301239632351.5,
      "cny": 13475048240375.172,
      "czk": 47773534022835.89,
      "dkk": 14490438153688.441,
      "eur": 1948300845831.609,
      "gbp": 1620647464749.4355,
      "hkd": 16602832619185.02,
      "huf": 737244495435479.1,
      "idr": 30452058292147230,
      "ils": 6832262774315.196,
      "inr": 160821521961969.78,
      "jpy": 263001452489445.12,
      "krw": 2591754190197418.5,
      "kwd": 645504531559.5071,
      "lkr": 635536811253313.2,
      "mmk": 3767017251717336,
      "mxn": 42651460723422.45,
      "myr": 8935007540134.893,
      "ngn": 880931116650413.2,
      "nok": 18660676093094.25,
      "nzd": 3074523544654.619,
      "php": 108890124071256.4,
      "pkr": 394144154750545.9,
      "pln": 9031466404171.959,
      "rub": 167889938626972.84,
      "sar": 7945469500621.211,
      "sek": 20038750657271.793,
      "sgd": 2884529326032.483,
      "thb": 70920235801316.17,
      "try": 31237486646749.547,
      "twd": 61032920478994.09,
      "uah": 62276907646607.35,
      "vef": 212123914083.16153,
      "vnd": 48429809426302610,
      "zar": 31256055168740.344,
      "xdr": 1523718297017.875,
      "xag": 86071804432.73659,
      "xau": 1096760926.3956187,
      "bits": 48491395603687.18,
      "sats": 4849139560368718
    },
    "total_volume": {
      "btc": 2398102.869525425,
      "eth": 32298013.774189048,
      "ltc": 917199975.4417744,
      "bch": 309799759.8179671,
      "bnb": 239701867.95413393,
      "eos": 41474203913.24943,
      "xrp": 132701442202.52759,
      "xlm": 489957712164.3488,
      "link": 6629693198.560509,
      "dot": 5107203405.23504,
      "yfi": 4907937.513871802,
      "usd": 104767972926.79518,
      "aed": 384823241357.41205,
      "ars": 11730952171472.004,
      "aud": 140048902113.81232,
      "bdt": 9033076710424.9,
      "bhd": 39502554656.102394,
      "bmd": 104767972926.79518,
      "brl": 498004082510.22906,
      "cad": 131854998951.20761,
      "chf": 97905670700.09016,
      "clp": 84235389383554.16,
      "cny": 666397645395.4668,
      "czk": 2362601603877.574,
      "dkk": 716612934819.2789,
      "eur": 96351647357.66707,
      "gbp": 80147813592.91724,
      "hkd": 821079699823.9097,
      "huf": 36459832059591.47,
      "idr": 1505981988437572.8,
      "ils": 337884046447.01904,
      "inr": 7953298693451.517,
      "jpy": 13006524766969.908,
      "krw": 128173113667703.47,
      "kwd": 31922906118.767467,
      "lkr": 31429960548294.074,
      "mmk": 186294800725599.7,
      "mxn": 2109293598935.1687,
      "myr": 441873593334.9695,
      "ngn": 43565738052978.586,
      "nok": 922848689525.6755,
      "nzd": 152048082821.09116,
      "php": 5385073284597.397,
      "pkr": 19492081363030.24,
      "pln": 446643888678.2708,
      "rub": 8302861540144.597,
      "sar": 392936787484.78094,
      "sek": 991000255914.5563,
      "sgd": 142652071937.12433,
      "thb": 3507303076458.0435,
      "try": 1544824714400.181,
      "twd": 3018333869629.1035,
      "uah": 3079854251939.5547,
      "vef": 10490417129.16001,
      "vnd": 2395057174781638,
      "zar": 1545743005682.884,
      "xdr": 75354259759.62456,
      "xag": 4256611685.964384,
      "xau": 54239427.26393104,
      "bits": 2398102869525.4253,
      "sats": 239810286952542.5
    },
    "market_cap_percentage": {
      "btc": 39.19374306182034,
      "eth": 18.412528086946384,
      "usdt": 3.897560435860709,
      "bnb": 3.470370428302752,
      "usdc": 2.404541413548596,
      "sol": 1.8262100020453709,
      "xrp": 1.7936483972221622,
      "luna": 1.7159473082148164,
      "ada": 1.6562541276504628,
      "avax": 1.110831691668897
    },
    "market_cap_change_percentage_24h_usd": 0.9388511973039788,
    "updated_at": 1649373489
  }
}
*/
