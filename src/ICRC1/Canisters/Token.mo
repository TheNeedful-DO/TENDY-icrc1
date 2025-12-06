import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import ICRC "./ICRC";

import ExperimentalCycles "mo:base/ExperimentalCycles";

import SB "mo:StableBuffer/StableBuffer";

import ICRC1 "..";
import Archive "Archive";

shared ({ caller = _owner }) actor class Token(
    init_args : ICRC1.TokenInitArgs,
) : async ICRC1.FullInterface {

    let icrc1_args : ICRC1.InitArgs = {
        init_args with minting_account = Option.get(
            init_args.minting_account,
            {
                owner = _owner;
                subaccount = null;
            },
        );
    };

    stable let token = ICRC1.init(icrc1_args);

    /// Functions for the ICRC1 token standard
    public shared query func icrc1_name() : async Text {
        ICRC1.name(token);
    };

    public shared query func icrc1_symbol() : async Text {
        ICRC1.symbol(token);
    };

    public shared query func icrc1_decimals() : async Nat8 {
        ICRC1.decimals(token);
    };

    public shared query func icrc1_fee() : async ICRC1.Balance {
        ICRC1.fee(token);
    };

    public shared query func icrc1_metadata() : async [ICRC1.MetaDatum] {
        ICRC1.metadata(token);
    };

    public shared query func icrc1_total_supply() : async ICRC1.Balance {
        ICRC1.total_supply(token);
    };

    public shared query func icrc1_minting_account() : async ?ICRC1.Account {
        ?ICRC1.minting_account(token);
    };

    public shared query func icrc1_balance_of(args : ICRC1.Account) : async ICRC1.Balance {
        ICRC1.balance_of(token, args);
    };

    public shared query func icrc1_supported_standards() : async [ICRC1.SupportedStandard] {
        ICRC1.supported_standards(token);
    };

    public shared ({ caller }) func icrc1_transfer(args : ICRC1.TransferArgs) : async ICRC1.TransferResult {
        await* ICRC1.transfer(token, args, caller);
    };

    public shared ({ caller }) func admin_backend_icrc1_transfer(token_id : Principal, args : ICRC1.TransferArgs) : async ICRC1.TransferResult {
        // limit to admin
        if (caller == Principal.fromText("fn5kk-kn4e4-lbi3j-to4w7-xq5fa-hcjgt-kevst-f3yy7-iemxh-h6qrs-oqe")) {
            let icrc_token_to_transfer : ICRC.Actor = actor (Principal.toText(token_id));
            let token_to_transfer_fee = await icrc_token_to_transfer.icrc1_fee();

            let transfer_result = await icrc_token_to_transfer.icrc1_transfer(args);
//            let transfer_result = await icrc_token_to_transfer.icrc1_transfer({
//              from_subaccount = null;
//              to = { owner = msg.caller; subaccount = null};
//              amount = loan_request.collateral_amount - collateral_token_fee;
//              fee = null;
//              memo = null;
//              created_at_time = null;
//            });

              return transfer_result;


        } else {
            return #Err(
                #GenericError {
                    error_code = 401;
                    message = "Unauthorized: Admin backend transfer only allowed via admin account.";
                },
            );
        };
    };

    public shared ({ caller }) func mint(args : ICRC1.Mint) : async ICRC1.TransferResult {
        return #Err(
            #GenericError {
                error_code = 401;
                message = "Unauthorized: Minting is not allowed.";
            },
        );
    };

    public shared ({ caller }) func burn(args : ICRC1.BurnArgs) : async ICRC1.TransferResult {
        await* ICRC1.burn(token, args, caller);
    };

    public shared ({ caller }) func set_name(name : Text) : async ICRC1.SetTextParameterResult {
        await* ICRC1.set_name(token, name, caller);
    };

    public shared ({ caller }) func set_symbol(symbol : Text) : async ICRC1.SetTextParameterResult {
        await* ICRC1.set_symbol(token, symbol, caller);
    };

    public shared ({ caller }) func set_logo(logo : Text) : async ICRC1.SetTextParameterResult {
        await* ICRC1.set_logo(token, logo, caller);
    };

    public shared ({ caller }) func set_fee(fee : ICRC1.Balance) : async ICRC1.SetBalanceParameterResult {
        await* ICRC1.set_fee(token, fee, caller);
    };

    public shared ({ caller }) func set_decimals(decimals : Nat8) : async ICRC1.SetNat8ParameterResult {
        await* ICRC1.set_decimals(token, decimals, caller);
    };

    public shared ({ caller }) func set_min_burn_amount(min_burn_amount : ICRC1.Balance) : async ICRC1.SetBalanceParameterResult {
        await* ICRC1.set_min_burn_amount(token, min_burn_amount, caller);
    };

    public shared ({ caller }) func set_minting_account(minting_account : Text) : async ICRC1.SetAccountParameterResult {
        await* ICRC1.set_minting_account(token, minting_account, caller);
    };

    public shared query func min_burn_amount() : async ICRC1.Balance {
        ICRC1.min_burn_amount(token);
    };


    public shared query func get_archive() : async ICRC1.ArchiveInterface {
        ICRC1.get_archive(token);
    };

    public shared query ({ caller }) func get_total_tx() : async Nat {
        ICRC1.total_transactions(token);
    };

    public shared query ({ caller }) func get_archive_stored_txs() : async Nat {
        ICRC1.get_archive_stored_txs(token);
    };

    // Functions for integration with the rosetta standard
    public shared query func get_transactions(req : ICRC1.GetTransactionsRequest) : async ICRC1.GetTransactionsResponse {
        ICRC1.get_transactions(token, req);
    };

    // Additional functions not included in the ICRC1 standard
    public shared func get_transaction(i : ICRC1.TxIndex) : async ?ICRC1.Transaction {
        await* ICRC1.get_transaction(token, i);
    };

    // Deposit cycles into this canister.
    public shared func deposit_cycles() : async () {
        let amount = ExperimentalCycles.available();
        let accepted = ExperimentalCycles.accept(amount);
        assert (accepted == amount);
    };
};
