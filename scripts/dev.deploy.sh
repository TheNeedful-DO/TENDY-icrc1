logo64="data:image/png;base64,$(base64 logo.png)"
# echo $logo64 > output.txt

# Reinstall

dfx identity use tendy_icrc1_dev

# dfx deploy icrc1 --mode reinstall --argument '( record {
dfx deploy icrc1 --argument '( record {
    name = "Tendies";
    symbol = "TENDY";
    decimals = 8;
    fee = 420;
    logo = "'"$logo64"'";
    max_supply = 88_000_00_000_000;
    initial_balances = vec {
        record {
            record {
                owner = principal "fn5kk-kn4e4-lbi3j-to4w7-xq5fa-hcjgt-kevst-f3yy7-iemxh-h6qrs-oqe";
                subaccount = null;
            };
            88_000_00_000_000
        }
    };
    min_burn_amount = 10_000;
    minting_account = null;
    advanced_settings = null;
})'

# default dfx identity / tendies dip20 marketing
# xayeg-i6mxe-4pwy5-wavxt-askxs-iudru-yplvi-2fiwe-ksjst-ordtl-4qe
# belobog dev identity
# fn5kk-kn4e4-lbi3j-to4w7-xq5fa-hcjgt-kevst-f3yy7-iemxh-h6qrs-oqe
