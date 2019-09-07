# You need MoneyMoney <b>v2.3.19</b> or a current beta version for this extension!

---

# moneymoney-hitbtc

Fetches balances from HitBTC.com API and returns them as securities. 
Prices in EUR from cryptocompare.com.
This extension is based on [moneymoney-binance](https://github.com/yoyostile/moneymoney-binance)

Requirements:
* MoneyMoney v2.3.19

## Extension Setup

You can get a signed version of this extension, which you need to run this in the non-beta client of MoneyMoney, from

* the `dist` directory in this repository or
* directly from the [extension download page of moneymoney](https://moneymoney-app.com/extensions/)

Once downloaded, move `hitbtc.lua` to your MoneyMoney Extensions folder. If you want to use the unsigned version, you need a non-AppStore based beta version of the moneymoney client.

## Account Setup

### HitBTC

1. Log in to your HitBTC account
2. Go to [Settings -> API keys](https://hitbtc.com/settings/api-keys)
3. Create new API key with "Order book, History, Trading balance" AND "Payment information" permissions. Only then, the balance fetch will work correctly.

### MoneyMoney

Add a new account (type "HitBTC Account") and use your HitBTC API key as username and your HitBTC API secret as password.