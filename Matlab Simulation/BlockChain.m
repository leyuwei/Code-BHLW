classdef BlockChain < handle
    properties
	totalCount    % 用来记录区块的个数
	blockArray    % 对象数组 用来盛放区块链
    end
    methods
	function obj = BlockChain()
	    obj.blockArray =[ Block(0,'Genesis Block','all available')];  % 构造blockchain对象时产生第一个 genesis block
	    obj.totalCount = 1 ;
	    obj.calculateGensisBlockHash();               % 计算genesis block的hash
	end
	function bc = getLatest(obj)                            
	    bc = obj.blockArray(end);
	end
	function calculateGensisBlockHash(obj) 
	    gb = obj.blockArray(1);
	    Opt.Method = 'SHA-256';
	    Opt.Input  = 'ascii';
	    str = strcat(num2str(gb.index),gb.data,gb.LD);     % 计算方法是把所有的内容做strcat
	    gb.selfHash = DataHash(  str , Opt);        % 然后hash
	end
	function addBlock(obj,newBlock)                 % 当miner成功的'挖出'一个符合要求的block之后
	   if  obj.validateNewBlock(newBlock)           % 调用该函数
	       obj.blockArray(end+1) = newBlock;        % 把这个block加到blockchain上去
	   end
	end
	function tf = validateNewBlock(obj,newBlock)    % 验证新添加的block是否符合要求
	   newHash = DataHash(  strcat( newBlock.getCombined(), num2str(newBlock.nonce) ));
	   if(strcmp(newHash(1:2),'00') && strcmp(newBlock.selfHash,newHash))
	       tf=  true;
	   else
	       tf = false;
	   end           
	end
    end
end