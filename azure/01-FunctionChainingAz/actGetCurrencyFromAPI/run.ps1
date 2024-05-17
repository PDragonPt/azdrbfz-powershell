# Define a parameter for the script to accept a currency
param($currency)

# Define a function to list exchange rates for a given currency
function ListExchangeRates { 
    # Define a parameter for the function to accept a currency string
    param([string]$currency)

    # Invoke a web request to the FloatRates API for the given currency, and parse the response content as XML
    [xml]$ExchangeRates = (invoke-webRequest -uri "http://www.floatrates.com/daily/$($currency).xml" -userAgent "curl" -useBasicParsing).Content 

    # Initialize an empty array to store the exchange rate items
    $all=@()

    # Get the 'item' elements from the XML response and store them in the 'items' variable
    $items= $ExchangeRates.channel.item

    # Loop through each item in the 'items' array
    foreach($Row in $items) {
        # Create a new PSObject with properties from the current item, and add it to the 'all' array
        $all+=new-object PSObject -property @{ 'BaseName'="$($Row.baseName)";'Rate' = "$($Row.exchangeRate)"; 'Currency' = "$($Row.targetCurrency) - $($Row.targetName)"; 'Inverse' = "$($Row.inverseRate)"; 'Date' = "$($Row.pubDate)" }
    }
    ## selecting 10 just for the demo
    # Return the 'all' array
    $all| Select-Object -First 10
}

# Call the 'ListExchangeRates' function with the currency parameter
ListExchangeRates -currency $currency