classdef Miner < handle
    properties
	blockchain              % miner拥有指向blockchain的reference 
    end
    methods
	function obj = Miner(blockchain)
	    obj.blockchain = blockchain;
	end

	function mine(obj,newData,LDavailablility)
	    % 获得当前blockchain上的最后一个block
	    latestBlock = obj.blockchain.getLatest();
	    %(1) 用来构造一个最新的block
	    %    需要的信息是index，并且把前一个block的selfHash当做自己的previousHash
	    newBlock = Block(latestBlock.index+1,newData,LDavailablility,latestBlock.selfHash);
	    % 暴力求解法来寻找符合规定的selfHash
	    not_found = true;
	    iter = 1;
	    Opt.Method = 'SHA-256';
	    Opt.Input  = 'ascii';
	    while(not_found)
		    newHash = DataHash(strcat( newBlock.getCombined(), num2str(iter) ));                
		    if( strcmp(newHash(1:2),'00') )
		        newBlock.nonce = iter;              % (2) 暴力求解 
		        newBlock.selfHash = newHash;        % 如果找到了赋值selfHash
		        obj.blockchain.addBlock(newBlock); % 把自己添加到blockchain上去
		        break
		    end
		    iter = iter + 1;
	    end
	end
    end
end