classdef Block < handle
    properties
	index                  % 区块号
	data                   % 交易数据
	previousHash           % 上一个区块的hash 
	selfHash               % 自己的hash
	nonce                  % 一个随机数
    LD                     % LD状态信息
    end   
    methods 
	function obj = Block(index,data,LD,previousHash)  % 构造函数
	    if nargin == 3       % genesis block  
	      obj.index = index ;
	      obj.data = data ;
          obj.LD = LD;

	    elseif nargin == 4                     
	      obj.index = index ;
	      obj.data = data ;
          obj.LD = LD;
	      obj.previousHash = previousHash;
	     end
	end
       function str = getCombined(obj)  % 这个函数把区块上的除nonce,selfHash的所有数据都转成字符，
					% 之后用来计算selfHash
	    str = strcat(num2str(obj.index),obj.previousHash,strjoin(obj.LD),strjoin(obj.data));
       end
     end
end