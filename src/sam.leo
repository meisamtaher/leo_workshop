program token.ale{
    mapping account: address => u64;
    record token {
        owner: address,
        amount: u64,
    }
    transition mint_public(public receiver: address, public amount: u64){
        return then finalize(receiver, amount);
    }
    finalize mint_pubic(public receiver:address, public amount:u64){
        let receiver_amount:u64 = Mapping::get_or_use(account, receiver, 0u64);
        Mapping::set(account, receiver, receiver_amount + amount);
    }
    transition mint_private(receiver:address, amount:u64) -> token {
        return token {
            owner: receiver,
            amount: amount
        };
    }
    transition transfer_public( public receiver:address, public amount:u64) {
        return then finalize(self.caller, receiver, amount);
    }
    finalize transfer_public(public sender: address, public receiver:address, public amount:u64){
        let sender_amount:u64 = Mapping::get_or_use(account, sender,0u64);
        Mapping::set(account, sender, sender_amount - amount);

        let receiver_amount:u64 = Mapping::get_or_use(account, receiver,0u64);
        Mapping::set(account, receiver, receiver_amount + amount);
    }

}