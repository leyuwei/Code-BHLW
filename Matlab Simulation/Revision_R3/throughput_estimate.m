function result=throughput_estimate(cfg)
% R3 correction to the supplied fixed-distance/dB-inconsistent estimator.
% Conditional Shannon link-rate study, NOT a standard-specific WiFi upper bound.
% Units: coordinates m, power W per independently usable channel, PSD W/Hz,
% bandwidth Hz per channel, shadowing normal in dB, output bit/s.
arguments
    cfg struct
end
rng(cfg.seed,'twister'); M=cfg.samples; C=cfg.channels;
if strcmp(cfg.spatial,'uniform')
    xy=reshape(cfg.room_xy,1,1,2).*rand(M,C,2);
elseif strcmp(cfg.spatial,'clustered')
    % A bounded cluster is specified explicitly, not a uniform-distance law.
    xy=reshape(cfg.cluster_center,1,1,2)+cfg.cluster_sigma_m*randn(M,C,2);
    xy=max(0,min(reshape(cfg.room_xy,1,1,2),xy));
elseif strcmp(cfg.spatial,'fixed')
    xy=repmat(reshape(cfg.fixed_xy,1,1,2),M,C,1);
else
    error('Unknown spatial distribution');
end
d=sqrt((xy(:,:,1)-cfg.ap_xy(1)).^2+(xy(:,:,2)-cfg.ap_xy(2)).^2+cfg.height_difference_m^2);
sigma=cfg.shadow_near_db*ones(size(d)); sigma(d>cfg.breakpoint_m)=cfg.shadow_far_db;
common=randn(M,1); independent=randn(M,C);
shadow=sigma.*(sqrt(cfg.shadow_correlation)*common+sqrt(1-cfg.shadow_correlation)*independent);
scatter=(randn(M,C)+1i*randn(M,C))/sqrt(2);
small=sqrt(cfg.rician_k/(cfg.rician_k+1))+sqrt(1/(cfg.rician_k+1))*scatter;
loss_db=20*log10(d)+20*log10(cfg.carrier_hz)-147.5+shadow;
% The response's Appendix-D study uses the manuscript's two-slope law.
% Absent this option, historical controlled studies retain their inputs.
if isfield(cfg,'path_loss_model') && strcmp(cfg.path_loss_model,'piecewise')
    loss_db=loss_db+35*log10(max(d/cfg.breakpoint_m,1));
end
gain=abs(small).^2.*10.^(-loss_db/10);
noise_w=cfg.bandwidth_hz*(1.380649e-23*cfg.temperature_k)*10^(cfg.noise_figure_db/10);
rate=cfg.bandwidth_hz*log2(1+cfg.power_per_channel_w*gain/noise_w);
aggregate=sum(rate,2);
result=struct('mean_bps',mean(aggregate),'standard_error_bps',std(aggregate)/sqrt(M),...
    'p05_bps',percentile(aggregate,.05),'p95_bps',percentile(aggregate,.95),...
    'outage_fraction',mean(aggregate<cfg.outage_threshold_bps),...
    'mean_distance_m',mean(d(:)),'mean_channel_gain',mean(gain(:)),...
    'samples',M,'cfg',cfg);
end

function value=percentile(x,p)
x=sort(x);value=x(max(1,ceil(numel(x)*p)));
end
