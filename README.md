```
$ curl -X 'GET' \
  'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h' \
  -H 'accept: application/json'

Reponse
{
    "id": "bitcoin",
    "symbol": "btc",
    "name": "Bitcoin",
    "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
    "current_price": 45735,
    "market_cap": 869390850667,
    "market_cap_rank": 1,
    "fully_diluted_valuation": 960769803976,
    "total_volume": 25787888908,
    "high_24h": 47322,
    "low_24h": 45617,
    "price_change_24h": -602.194273282068,
    "price_change_percentage_24h": -1.29959,
    "market_cap_change_24h": -10708494316.060669,
    "market_cap_change_percentage_24h": -1.21674,
    "circulating_supply": 19002687,
    "total_supply": 21000000,
    "max_supply": 21000000,
    "ath": 69045,
    "ath_change_percentage": -33.73667,
    "ath_date": "2021-11-10T14:24:11.849Z",
    "atl": 67.81,
    "atl_change_percentage": 67370.93321,
    "atl_date": "2013-07-06T00:00:00.000Z",
    "roi": null,
    "last_updated": "2022-04-04T17:06:34.066Z",
    "sparkline_in_7d": {
      "price": [
        47160.22324298433,
        47557.11474929997,
        45977.43657764148
        ...
      ]
    },
    "price_change_percentage_24h_in_currency": -1.2995868402231314
  },
```
