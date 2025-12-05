logo64="data:image/png;base64,$(base64 logo.png)"
# dfx identity use tendy_icrc1

dfx --identity tendy_icrc1 deploy icrc1 --argument '( record {
    name = "Tendies";
    symbol = "TENDY";
    decimals = 8;
    fee = 420;
    logo = "'"$logo64"'";
    max_supply = 88_000_00_000_000;
    initial_balances = vec {
        record {
            record {
                owner = principal "peg2s-47dqj-7dnez-bznad-kclyo-rxbc7-oor7s-wc3kx-e5k23-ziivp-oqe";
                subaccount = null;
            };
            88_000_00_000_000
        }
    };
    min_burn_amount = 10_000;
    minting_account = null;
    advanced_settings = null;
})' --network ic
