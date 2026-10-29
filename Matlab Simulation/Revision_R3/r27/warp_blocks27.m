function wall=warp_blocks27(base,period,duty,miners)
% Invert accumulated hash-time when one equal-power peer is intermittently down.
assert(period>0 && duty>=0 && duty<=1 && miners>1);
if duty==0,wall=base;return;end
up=period*(1-duty);effective=period*(1-duty/miners);
cycles=floor(base/effective);remainder=base-cycles*effective;
phase=remainder;down=remainder>up;
phase(down)=up+(remainder(down)-up)/(1-1/miners);
wall=cycles*period+phase;
assert(all(wall>=base-1e-9) && all(diff(wall)>=0));
end
