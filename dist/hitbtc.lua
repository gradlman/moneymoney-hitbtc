-- Inofficial HitBTC Extension (www.hitbtc.com) for MoneyMoney
-- Fetches balances from HitBTC API and returns them as securities
--
-- Username: HitBTC API Key
-- Password: HitBTC API Secret
--
-- Written 2019 by S Gradl based on code (c) by Johannes Heck
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

WebBanking {
  version     = 1.0,
  url         = "https://api.hitbtc.com/api/2",
  description = "Fetch balances from HitBTC API and list them as securities",
  services    = { "HitBTC Account" },
}

local apiKey
local apiSecret
local currency

local currencySymbols = {
  BCC  = "BCH",
  IOTA = "IOT",
  NANO = "XRB",
  YOYO = "YOYOW"
}

function SupportsBank (protocol, bankCode)
  return protocol == ProtocolWebBanking and bankCode == "HitBTC Account"
end

function InitializeSession (protocol, bankCode, username, username2, password, username3)
  apiKey = username
  apiSecret = password
  currency = "EUR"
end

function ListAccounts (knownAccounts)
  local account = {
    name = market,
    accountNumber = "HitBTC Account",
    currency = currency,
    portfolio = true,
    type = "AccountTypePortfolio"
  }

  return {account}
end

function RefreshAccount (account, since)
  jtable = queryPrivate("account")
  local eurPrices = queryCryptoCompare("pricemulti", "?fsyms=" .. assetPrices(jtable) .. "&tsyms=EUR")
  local fallbackTable = {}
  fallbackTable["EUR"] = 0

  local s = {}
  for key, value in pairs(jtable) do
    if tonumber(value["available"]) > 0 then
      s[#s+1] = {
        name = value["currency"],
        market = market,
        currency = nil,
        quantity = value["available"],
        price = (eurPrices[symbolForAsset(value["currency"])] or fallbackTable)["EUR"],
      }
    end
  end

  return {securities = s}
end

function symbolForAsset(asset)
  return currencySymbols[asset] or asset
end

function assetPrices(jtable)
  local assets = ""
  for key, value in pairs(jtable) do
    if tonumber(value["available"]) > 0 then
      assets = assets .. symbolForAsset(value["currency"]) .. ','
    end
  end
  return assets
end

function EndSession ()
end

function queryPrivate(method)
  local path = string.format("/%s/%s", method, "balance")
  local authString = apiKey .. ":" .. apiSecret
  local authCode = MM.base64(authString)

  local headers = {}
  headers["Accept"] = "application/json"
  headers["Authorization"] = "Basic " .. authCode

  connection = Connection()
  content = connection:request("GET", url .. path, nil, nil, headers)
  return JSON(content):dictionary()
end

function queryCryptoCompare(method, query)
  local path = string.format("/%s/%s", "data", method)
  connection = Connection()
  content = connection:get("https://min-api.cryptocompare.com" .. path .. query)
  return JSON(content):dictionary()
end

-- SIGNATURE: MCwCFHV9d6vqYY4w0By5xVUMAykbiEyPAhR6zns9p9bIAlZdJpAtfXBlWxVSeQ==
