% WiFi aggregate rate using the finalized square-room propagation model.
here=fileparts(mfilename('fullpath'));
previous_path=path;
addpath(fullfile(here,'Revision_R3'));
configuration=paper_wifi_configuration();
result=estimate_wifi_reference(configuration);
E_result=result.mean_bps;
fprintf('WiFi aggregate rate: %.6f Gbit/s\n',E_result/1e9);
path(previous_path);
