function run_revision_suite()
% Reproduce the current reply using self-contained, seeded native MATLAB runs.
here=fileparts(mfilename('fullpath'));
addpath(here,fullfile(here,'r25'),fullfile(here,'r26'),fullfile(here,'r27'),fullfile(here,'r32'));
previous=fullfile(here,'results','revision25','matlab');
run_response_revision25(previous);
run_response26(fullfile(here,'results','revision26','matlab'),previous);
run_response32();
fprintf('PASS: complete current-response MATLAB suite.\n');
end
