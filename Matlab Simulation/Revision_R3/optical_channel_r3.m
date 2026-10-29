function H = optical_channel_r3(receiver, ld, cfg)
% Same Lambertian intensity gain and FoV check as the supplied OWC script.
% Rows are receivers, columns are LDs. Distances/heights are in metres.
dx = receiver(:,1) - ld(:,1)';
dy = receiver(:,2) - ld(:,2)';
dz = ld(:,3)' - receiver(:,3);
d2 = dx.^2 + dy.^2 + dz.^2;
cosine = dz ./ sqrt(d2);
H = ((cfg.lambertian_order+1)*cfg.pd_area_m2) ./ (2*pi*d2) .* cosine.^(cfg.lambertian_order+1);
H(dz<=0 | cosine<cosd(cfg.fov_deg) | ~isfinite(H)) = 0;
end
